extends Node2D



var devMode = false
@onready var devText = $titleScreen/devText



@onready var bradyTweak = $titleScreen/bradyTweakTs

@onready var camera = $Camera2D
@onready var cameraTsLocation = $titleScreen/cameraTsPoint
@onready var cameraHtpLocation = $howToPlayScreen/cameraHtpPoint
@onready var cameraOfficeLocation = $officeScreen/cameraOfficePoint
@onready var cameraCamsLocation = $camsScreen/cameraCamsPoint
@onready var cameraGameoverLocation = $gameoverScreen/cameraGameoverPoint
@onready var cameraWinLocation = $winScreen/winCamsPoint

@onready var doorLClosedSprite = $officeScreen/doorLClosed
@onready var doorLOpenSprite = $officeScreen/doorLOpen
@onready var doorRClosedSprite = $officeScreen/doorRClosed
@onready var doorROpenSprite = $officeScreen/doorROpen

@onready var krishFace = $officeScreen/krishFace

@onready var musicBoxWinder = $officeScreen/puppetTimerCircle

@onready var krishPos0 = $officeScreen/puppetBox/krishPos0
@onready var krishPos1 = $officeScreen/puppetBox/krishPos1
@onready var krishPos2 = $officeScreen/puppetBox/krishPos2
@onready var krishPos3 = $officeScreen/puppetBox/krishPos3

@onready var camsBrady = $camsScreen/camsBrady
@onready var camsTommy = $camsScreen/camsTommy

@onready var camText = $camsScreen/camText
@onready var powerText = $officeScreen/powerText
@onready var usageText = $officeScreen/usageText
@onready var timeText = $officeScreen/timeText

@onready var testJS = $jumpscareAnimations/testJS
@onready var bradyJS = $jumpscareAnimations/bradyJS
@onready var tommyJS = $jumpscareAnimations/tommyJS
@onready var krishJS = $jumpscareAnimations/krishJS

@onready var deathBrady = $gameoverScreen/deathFaces/deathBrady
@onready var deathTommy = $gameoverScreen/deathFaces/deathTommy
@onready var deathKrish = $gameoverScreen/deathFaces/deathKrish

@onready var jumpscareAnimations = $jumpscareAnimations 
@onready var testJSAnimation = $jumpscareAnimations/testJS/testJSAnimation
@onready var bradyJSAnimation = $jumpscareAnimations/bradyJS/bradyJSAnimation
@onready var tommyJSAnimation = $jumpscareAnimations/tommyJS/tommyJSAnimation
@onready var krishJSAnimation =  $jumpscareAnimations/krishJS/krishJSAnimation
@onready var jsAnimationTimer = $jumpscareAnimations/jumpscareTimer

@onready var hoursTimer = $hourTimer
@onready var powerOutTimer = $powerOutTimer

@onready var darkness = $officeScreen/darkness

var gameStarted = false

var bradyLocation = 7
var bradyMoveTimer = 15
var bradyMoveTimerReset = 15
var tommyLocation = 7
var tommyMoveTimer = 15
var tommyMoveTimerReset = 15
var krishTimer = 9
var maxKrishTimer = 9

var windSpeed = 2
var unwindSpeed = 0.75
var maxWind = 9
var mouseOverWinder = false

var powerTimer = 180
var powerTimerReset = 180
var power = 100
var usage = 1

var currentTime = 0

var doorLOpen = true
var doorROpen = true
var currentCam = 7
var disabledCam = 0
var disabledCamTimer = 10

func _ready() -> void:
	if devMode == true:
		devText.visible = true
	
	jumpscareAnimations.global_position = Vector2(3680, 404)
	testJS.visible = false
	bradyJS.visible = false
	tommyJS.visible = false
	krishJS.visible = false

func _process(delta: float) -> void:
	if gameStarted == true:
		gameSequence(delta)
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

func gameSequence(delta: float):
	#Dev mode
	if devMode == true:
		doDevMode()
	
	#Handle the puppet's timer and updating the music box winder
	krishTimer -= unwindSpeed * delta
	if Input.is_action_pressed("leftClick") && mouseOverWinder == true && krishTimer <= maxKrishTimer:
		krishTimer += windSpeed * delta
	#region Puppet visuals and jumpscare trigger
	if krishTimer >= 8:
		musicBoxWinder.set_frame_and_progress(0, 0.0)
		krishFace.position.y = krishPos0.position.y
	elif krishTimer >= 7:
		musicBoxWinder.set_frame_and_progress(1, 0.0)
		krishFace.position.y = krishPos0.position.y
	elif krishTimer >= 6:
		musicBoxWinder.set_frame_and_progress(2, 0.0)
		krishFace.position.y = krishPos0.position.y
	elif krishTimer >= 5:
		musicBoxWinder.set_frame_and_progress(3, 0.0)
		krishFace.position.y = krishPos1.position.y
	elif krishTimer >= 4:
		musicBoxWinder.set_frame_and_progress(4, 0.0)
		krishFace.position.y = krishPos1.position.y
	elif krishTimer >= 3:
		musicBoxWinder.set_frame_and_progress(5, 0.0)
		krishFace.position.y = krishPos2.position.y
	elif krishTimer >= 2:
		musicBoxWinder.set_frame_and_progress(6, 0.0)
		krishFace.position.y = krishPos2.position.y
	elif krishTimer >= 1:
		musicBoxWinder.set_frame_and_progress(7, 0.0)
		krishFace.position.y = krishPos2.position.y
	elif krishTimer >= 0:
		musicBoxWinder.set_frame_and_progress(8, 0.0)
		krishFace.position.y = krishPos3.position.y
	else:
		if devMode == false:
			krishJumpscare()
		krishTimer = 9
	#endregion
	
	#Move Brady and Tommy
	bradyMoveTimer -= randf_range(1.0, 1.5) * delta
	tommyMoveTimer -= 1 * delta
	var willBradyMove = randi_range(1,3)
	if bradyMoveTimer <= 0:
		if willBradyMove >= 2:
			if bradyLocation == 7:
				bradyLocation = randi_range(5, 6)
			elif bradyLocation == 6 :
				bradyLocation = 4
			elif bradyLocation == 5:
				bradyLocation = 3
			elif bradyLocation == 4:
				bradyLocation = 2
			elif bradyLocation == 3:
				bradyLocation = 1
			elif bradyLocation == 2 and doorROpen == true:
				bradyLocation = 0
			elif bradyLocation == 1 and doorLOpen == true:
				bradyLocation = 0
			else:
				bradyLocation = 7
		bradyMoveTimer = bradyMoveTimerReset
	
	var willTommyMove = randi_range(1,3)
	var possibleTommyLocations = [6, 4, 2]
	if tommyMoveTimer <= 0:
		if willTommyMove == 1:
			if tommyLocation == 2:
				if doorROpen == true:
					tommyLocation = 0
				else:
					tommyLocation = possibleTommyLocations.pick_random()
			else:
				tommyLocation = possibleTommyLocations.pick_random()
		tommyMoveTimer = tommyMoveTimerReset
	
	#Update the current disabled camera
	if devMode == false:
		disabledCamTimer -= 1 * delta
		if disabledCamTimer <= 0:
			disabledCam = randi_range(1,7)
			disabledCamTimer = randi_range(7,13)
	
	#Change the doors when the keys are pressed
	if Input.is_action_just_pressed("a"):
		if doorLOpen == true:
			doorLOpen = false
			usage += 1
		else:
			doorLOpen = true
			usage -= 1
	if Input.is_action_just_pressed("d"):
		if doorROpen == true:
			doorROpen = false
			usage += 1
		else:
			doorROpen = true
			usage -= 1
	
	#Take away power
	powerTimer -= 1 * usage
	if powerTimer <= 0:
		power -= 1
		powerTimer = powerTimerReset
	
	#Show whether or not the doors are open
	if doorLOpen == true:
		doorLOpenSprite.visible = true
		doorLClosedSprite.visible = false
	else:
		doorLOpenSprite.visible = false
		doorLClosedSprite.visible = true
	if doorROpen == true:
		doorROpenSprite.visible = true
		doorRClosedSprite.visible = false
	else:
		doorROpenSprite.visible = false
		doorRClosedSprite.visible = true
	
	#Show the power and time
	powerText.text = "Power: " + str(power)
	usageText.text = "Usage: " + str(usage)
	if currentTime == 0:
		timeText.text = "12:00"
	else:
		timeText.text = "0" + str(currentTime) + ":00"
	
	#Show what is on the cameras
	if currentCam != disabledCam:
		if currentCam == bradyLocation:
			camsBrady.visible = true
		else:
			camsBrady.visible = false
		if currentCam == tommyLocation:
			camsTommy.visible = true
		else:
			camsTommy.visible = false
		camText.text = "Camera " + str(currentCam)
	else:
		camsBrady.visible = false
		camsTommy.visible = false
		camText.text = "Camera disabled"
	
	#Detect and play hallway jumpscares
	if bradyLocation == 0:
		if devMode == false:
			bradyJumpscare()	
		bradyLocation = 7
	
	if tommyLocation == 0:
		if devMode == false:
			tommyJumpscare()
		tommyLocation = 7
	
	#Dectect the running out of power jumpscare
	if power <= 0:
		losePowerSequence()
	
	#Dectect when the night is over and make the player win the game
	if currentTime == 6:
		winSequence()

func gameSetup():
	power = 100
	usage = 1
	doorROpen = true
	doorLOpen = true
	bradyLocation = 7
	bradyMoveTimer = 15
	tommyLocation = 7
	tommyMoveTimer = 15
	krishTimer = maxKrishTimer
	powerTimer = powerTimerReset
	currentTime = 0
	currentCam = 7
	disabledCam = 0
	disabledCamTimer = 10
	testJS.visible = false
	bradyJS.visible = false
	tommyJS.visible = false
	krishJS.visible = false
	powerText.visible = true
	timeText.visible = true
	usageText.visible = true
	darkness.visible = false
	deathBrady.visible = false
	deathTommy.visible = false
	deathKrish.visible = false

func testJumpscare():
	gameStarted = false
	bradyJS.visible = false
	tommyJS.visible = false
	krishJS.visible = false
	testJSAnimation.play("jumpscareTest")
	jsAnimationTimer.start()
	camera.global_position = cameraOfficeLocation.global_position

func bradyJumpscare():
	gameStarted = false
	testJS.visible = false
	tommyJS.visible = false
	krishJS.visible = false
	bradyJSAnimation.play("jumpscareBrady")
	jsAnimationTimer.start()
	deathBrady.visible = true
	camera.global_position = cameraOfficeLocation.global_position

func tommyJumpscare():
	gameStarted = false
	testJS.visible = false
	bradyJS.visible = false
	krishJS.visible = false
	tommyJSAnimation.play("jumpscareTommy")
	jsAnimationTimer.start()
	deathTommy.visible = true
	camera.global_position = cameraOfficeLocation.global_position

func krishJumpscare():
	gameStarted = false
	testJS.visible = false
	bradyJS.visible = false
	tommyJS.visible = false
	krishFace.visible = false
	krishJSAnimation.play("jumpscareKrish")
	jsAnimationTimer.start()
	deathKrish.visible = true
	camera.global_position = cameraOfficeLocation.global_position

func losePowerSequence():
	gameStarted = false
	camera.global_position = cameraOfficeLocation.global_position
	powerText.visible = false
	timeText.visible = false
	usageText.visible = false
	darkness.visible = true
	powerOutTimer.wait_time = randi_range(5, 10)
	powerOutTimer.start()
	deathBrady.visible = true

func winSequence():
	gameStarted = false
	camera.global_position = cameraWinLocation.global_position

func doDevMode():
	if Input.is_action_just_pressed("1"):
		testJumpscare()
	if Input.is_action_just_pressed("2"):
		bradyJumpscare()
	if Input.is_action_just_pressed("3"):
		tommyJumpscare()
	if Input.is_action_just_pressed("4"):
		krishJumpscare()
	if Input.is_action_just_pressed("5"):
		losePowerSequence()
	if Input.is_action_just_pressed("6"):
		winSequence()

#Start button
func _on_start_button_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		camera.global_position = cameraOfficeLocation.global_position
		gameStarted = true
		hoursTimer.start()

#How to play button
func _on_how_to_play_button_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		camera.global_position = cameraHtpLocation.global_position

#Back to menu button
func _on_back_to_menu_button_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		camera.global_position = cameraTsLocation.global_position
		bradyTweak.set_frame_and_progress(0, 0.0)

#Music box winder
func _on_area_2d_mouse_entered() -> void:
	mouseOverWinder = true
func _on_area_2d_mouse_exited() -> void:
	mouseOverWinder = false

#Cams button
func _on_cams_button_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick") && gameStarted == true:
		camera.global_position = cameraCamsLocation.global_position

#Back to office button
func _on_office_button_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		camera.global_position = cameraOfficeLocation.global_position

#region different camera buttons
#Cam 1
func _on_cam_1_label_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		currentCam = 1

#Cam 2
func _on_cam_2_label_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		currentCam = 2

#Cam 3
func _on_cam_3_label_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		currentCam = 3

#Cam 4
func _on_cam_4_label_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		currentCam = 4

#Cam 5
func _on_cam_5_label_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		currentCam = 5

#Cam 6
func _on_cam_6_label_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		currentCam = 6

func _on_cam_7_label_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		currentCam = 7
#endregion

#Door button left
func _on_door_button_l_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		if doorLOpen == true:
			doorLOpen = false
			usage += 1
		else:
			doorLOpen = true
			usage -= 1

#Door button right
func _on_door_button_r_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		if doorROpen == true:
			doorROpen = false
			usage += 1
		else:
			doorROpen = true
			usage -= 1

#Jumpscare animation timer
func _on_jumpscare_timer_timeout() -> void:
	camera.global_position = cameraGameoverLocation.global_position

#Hours timer
func _on_hour_timer_timeout() -> void:
	currentTime += 1
	hoursTimer.start()

#Power out timer
func _on_power_out_timer_timeout() -> void:
	bradyJumpscare()

#Restart button
func _on_restart_button_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		gameSetup()
		camera.global_position = cameraOfficeLocation.global_position
		gameStarted = true

#Quit button
func _on_quit_button_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		gameSetup()
		camera.global_position = cameraTsLocation.global_position
