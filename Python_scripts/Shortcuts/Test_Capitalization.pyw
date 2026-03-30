import sys
import os

# Redirect stdout and stderr to suppress output
sys.stdout = open(os.devnull, 'w')
sys.stderr = open(os.devnull, 'w')

# Execute the original script
exec(open(r"""d:\_installed\_productivity\_MyMacros\Python scripts\Clipboard Manipulation\Test Capitalization.py""").read())
