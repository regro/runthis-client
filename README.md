# runthis-client
This is a web client for the RunThis project. This project makes it easy to
connect to a RunThis server.

The client here displays a "Run This" button and placeholder HTML so that the
terminal session is not started when the page first loads. Clicking the
RunThis button will cause the placeholder HTML to be replaced by an active
connection to the terminal session.

## Downloads
The client is available on the GitHub releases page: https://github.com/regro/runthis-client/releases

## Usage
This project is an [elm](https://elm-lang.org/) application that can be used mutliple times
within a page. Here is a basic example that load the minified version of the JavaScript,
and passes in valid parameters to the application and onto the RunThis Server.

```html
<html>
<head>
  <meta charset="UTF-8">
  <title>RunThis Client Example</title>
  <link rel="stylesheet" href="css/theme.css">
  <script src="path/to/runthis-client.min.js"></script>
</head>

<body>
  <div id="elm"></div>
  <script>
  var app = Elm.Main.init({
    node: document.getElementById('elm'),
    flags: {
        <!-- HTML to be displayed prior to "Run This" button click -->
        placeholder: "I'm here",

        <!-- The base URL of the RunThis Server -->
        serverUrl: "http://localhost:5000",

        <!-- Code to be run silently at the start of the command -->
        presetup: "import sys",

        <!-- Initial code to be run and echoed to the screen -->
        setup: "print(sys.executable)"
    }
  });
  </script>
</body>
</html>
```
