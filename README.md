## Validity (deprecating)
Open AI API - used in this case with a browser based extention that will make request with a Youtube URL video ID to check the validity of the video captions itself.

## Things to note:
- There are no tests
- This is a MVP
- No exDocs or docs for the repo
---

### Prerequesites
- Erlang/Elixir
- Python
- `mix deps.get` to install the dependencies
- `iex -S mix phx.server`

### Note
Make sure to add the `.env` file with the keys below

```
# OpenAI_API_key
OPEN_AI_API=OPEN_API_KEY
OPEN_AI_MODEL=text-davinci-003

# system - see config
PORT=4000
```

This needs to be run with `source .env` before starting the the server using `iex -S mix phx.server` - You should then be able to access the API by making a GET request to the server with the below example data

```
url: localhost:4000/api/validate/[YOUTUBE_VIDEO_ID]
request type: GET
``` 

This should return the result and score.

Feel free to check the extension by install that exists in the `lib/extension` folder, and you can install it in the browser and navigate to Youtube and wait for the option to make the request.
