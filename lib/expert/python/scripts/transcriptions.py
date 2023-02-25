import sys
from youtube_transcript_api import YouTubeTranscriptApi

# get transcriptions of the video
def get_transcription(input):
    return YouTubeTranscriptApi.get_transcript(input)

# check the main function
# take args as params to pass to function
# output the response - success/error
if __name__ == '__main__':
    input = sys.argv[1]
    output_string = get_transcription(input)
    print(output_string)
