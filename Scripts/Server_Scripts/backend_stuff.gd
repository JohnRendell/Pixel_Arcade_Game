extends Node

#http request
var http_request := HTTPRequest.new()
var backend_url := "http://localhost:8080"
var returned_parsed: Dictionary

func _ready():
	if not http_request.is_inside_tree():
		add_child(http_request)
	
	#connect once
	if not http_request.request_completed.is_connected(_on_request_completed):
		http_request.request_completed.connect(_on_request_completed)

func send_data_to_express(data, route):
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	var url = backend_url + route
	
	print(json)
	print(url)
	http_request.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		json
	)

func _on_request_completed(_result, _response_code, _headers, body):
	var response = body.get_string_from_utf8()
	var parsed = JSON.parse_string(response)

	if parsed:
		print("Returned from request: " + str(parsed))
		returned_parsed = parsed
	else:
		print("⚠️ Invalid or no response from backend.")
