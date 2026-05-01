extends Node

func _ready():
	Firebase.Auth.login_succeeded.connect(_on_auth_success)
	Firebase.Auth.signup_succeeded.connect(_on_auth_success)
	Firebase.Auth.login_failed.connect(_on_auth_failed)
	Firebase.Auth.signup_failed.connect(_on_auth_failed)
	Firebase.Auth.login_anonymous()

func _on_auth_success(auth):
	print("Firebase authenticated. User ID: ", auth.localid)

func _on_auth_failed(error_code, message):
	print("Firebase auth failed: ", error_code, " - ", message)
