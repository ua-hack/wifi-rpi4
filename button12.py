import pyautogui
import time
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)

GPIO.setup(12, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(16, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(18, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(22, GPIO.IN, pull_up_down = GPIO.PUD_UP)

while True:
	if(GPIO.input(12) == 0):
		pyautogui.press("enter")
		time.sleep(0.3)
	if(GPIO.input(16) == 0):
		pyautogui.press("up")
		time.sleep(0.3)
	if(GPIO.input(18) == 0):
		pyautogui.press("down")
		time.sleep(0.3)
	if(GPIO.input(22) == 0):
		pyautogui.hotkey('ctrl', 'c')
		time.sleep(0.3)
GPIO.cleanup()

# Holds down the alt key
#pyautogui.keyDown("alt")

# Presses the tab key once
#pyautogui.press("tab")

# Lets go of the alt key
#pyautogui.keyUp("alt")
