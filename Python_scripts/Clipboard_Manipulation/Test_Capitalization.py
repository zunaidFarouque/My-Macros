import pyperclip

# Get current clipboard content
clipboard_text = pyperclip.paste()

# Capitalize the text
capitalized_text = clipboard_text.upper()

# Set the capitalized text back to clipboard
pyperclip.copy(capitalized_text)

print(f"Original: {clipboard_text}")
print(f"Capitalized: {capitalized_text}")
print("Clipboard updated!")
