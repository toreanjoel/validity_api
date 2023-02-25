import sys
from youtube_transcript_api import YouTubeTranscriptApi

# get transcriptions of the video
def get_transcription(input):
    transcript = YouTubeTranscriptApi.get_transcript(input)
    script = ""

    for text in transcript:
        t = text["text"]
        script += t + ". "
		
    return script, len(script.split())

# check the main function
# take args as params to pass to function
# output the response - success/error
if __name__ == '__main__':
    input = sys.argv[1]
    output_string = get_transcription(input)
    print(output_string)
