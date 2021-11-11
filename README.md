# jarvisplayer

A Flutter android app to use voice for finding recipes.

## Getting Started
Create an account at https://spoonacular.com/food-api/console#Dashboard and add the apiKey to constants.dart to run the application.

### Wake word is "Jarvis"

## Commands:
"What can I cook with {ingredients name}",
"Next step",
"Previous step",
"Scroll up",
"Scroll down".

## Picovoice
Picovoice is used here and upload your own picovoice files if you want diffferent commands and modify picovoicemanager.dart accordingly. Just the inferencecallback() function can be modified. (.ppn and .rhn files).
