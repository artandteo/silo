      document.addEventListener("turbolinks:load", function() {
      window.cookieconsent.initialise({
        "palette": {
          "popup": {
            "background": "#000"
          },
          "button": {
            "background": "#f1d600"
          }
        },
        "content": {
          "message": "Nous utilisons des cookies pour vous garantir la meilleure expérience sur notre site. Si vous continuez à utiliser ce dernier, nous considérerons que vous acceptez l'utilisation des cookies. ",
          "dismiss": "Ok",
          "link": "En savoir plus"
        }
      })});
