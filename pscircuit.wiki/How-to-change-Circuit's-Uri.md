**How to use it in the Circuit Production Uri**

It's set to the Circuit Sandbox by default. It's very simple to change it, just edit the config file:

Replace `'https://circuitsandbox.net'` with `'https://eu.yourcircuit.com'`

![image](uploads/53a79fc494da15c402b457aab11dad46/image.png)

if you find it too complicated, delete line 4 and 5 and replace with the following:

```powershell
        # Uri = 'https://circuitsandbox.net'   # Use this for the Sandbox environment
          Uri = 'https://eu.yourcircuit.com' # Use this for the Production environment
```

Save and Import the module again with the `-Force` parameter:
```powershell
Import-Module PSCircuit -Force -Verbose
```
![image](uploads/0aaca4249be066cf8c3f3a316337cee8/image.png)

Happy learning! - E3k