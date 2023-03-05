import sys
from gensim.summarization import summarize

# get summart of text
def summarize_text(input):
    # NOTE: we need to pass the value for the summary
    return summarize(input, word_count = 400)

# check the main function
# take args as params to pass to function
# output the response - success/error
if __name__ == '__main__':
    input = sys.argv[1]
    # limit = sys.argv[2]
    output_string = summarize_text(input)
    print(output_string)
