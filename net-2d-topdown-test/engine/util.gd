extends Node

func checked_connect(src_of_event, event_name, target_ref, target_func_name):
    if src_of_event.connect(event_name, target_ref, target_func_name) != OK:
        print(
            "Error connecting ", event_name, 
            " to ", target_func_name, 
            " emit from ", src_of_event,
            " to ", target_func_name
        )
