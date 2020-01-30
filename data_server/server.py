#
# Websocket broker
#
# @author Glenn De Backer <glenn@simplicity.be>
#

# tornado
import tornado.ioloop
import tornado.web
import tornado.websocket
import tornado.template

# standard lib
import socket
import functools
import json

class Notifier():
    """ Notifier utility class """

    _callbacks = []

    def register_callback(self, callback):
        """ register callback """
        self._callbacks.append(callback)

    def remove_callback(self, callback):
        """ remove callback """
        self._callbacks.remove(callback)

    def notify(self, data):
        """ notify """
        for callback in self._callbacks:
            callback(data) # callback

notifier = Notifier()

class WSHandler(tornado.websocket.WebSocketHandler):
    """ WebSocket handler """

    def initialize(self, notifier):
        """ initialize when a new websocket connects """
        self._notifier = notifier
        self._notifier.register_callback(self.process_notification)

    def process_notification(self, data):
        """ process notification """
        self.write_message(data)

    def open(self):
        """ when a websocket connect """
        pass

    def on_message(self, message):
        print('received message: %s\n' % message)
        self.write_message(message + ' OK')

    def on_close(self):
        """ when the websocket disconnects"""
        # remove callback so it doesn't get called in the future
        self._notifier.remove_callback(self.process_notification)

class HTMLHandler(tornado.web.RequestHandler):
    """ HTML handler """
    def get(self):
        loader = tornado.template.Loader(".")
        self.write(loader.load("index.html").generate())

@tornado.gen.coroutine
def handle_udp_messages(sock, fd, events):
    """ Handles UDP messages it receives """
    while True:
        try:
            data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes

            if not data:
                print("connection closed")
                sock.close()
                break
            else:
                print("Received %d bytes: '%s'" % (len(data), data))

                # notify that we have new data
                notifier.notify(data)
        except socket.error as e:
            break

# setup application routes
application = tornado.web.Application([
  (r'/ws', WSHandler, dict(notifier=notifier)),
  (r'/', HTMLHandler),
  (r'/static/(.*)', tornado.web.StaticFileHandler, {'path': 'static'}),
])

if __name__ == '__main__':
    # Read configuration
    server_port = 9090
    udp_port    = 9999

    # application start listening on port 9090
    application.listen(server_port)

    # setup socket for UDP listening
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(('',udp_port))
    sock.setblocking(False)

    # create handler that deals with our UDP messages
    io_loop = tornado.ioloop.IOLoop.current()
    callback = functools.partial(handle_udp_messages, sock)
    io_loop.add_handler(sock.fileno(), callback, io_loop.READ)

    io_loop.start()
