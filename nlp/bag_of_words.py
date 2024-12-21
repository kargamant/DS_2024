stop_words = []
with open("stop_words.txt", 'r') as file:
    stop_words = file.read().split('\n')
print(stop_words)

def read_content(filename: str):
    with open(filename, 'r') as file:
        content = file.read().replace('\n', ' ').replace('!', '').replace('?', '').replace(',', '').replace('.', '').lower().split(' ')
    content = list(filter(lambda x: x!='', content))
    return content

def stop_words_remove(content, stop_words):
    for st in stop_words:
        if st in content:
            content = list(filter(lambda x: x!=st, content))
    return content

def form_bag_of_words(content):
    bag_of_words = {}
    for w in content:
        bag_of_words[w] = 0

    for w in content:
        bag_of_words[w]+=1
    return bag_of_words

content = read_content('yoyodine_bank_review.txt')
print(content, end='\n\n')

content = stop_words_remove(content, stop_words)
print(content, end='\n\n')

bag_of_words = form_bag_of_words(content)

print(bag_of_words)

content = read_content('reuters.txt')
content = stop_words_remove(content, stop_words)
print(content, end='\n\n')

bag_of_words = form_bag_of_words(content)
top = [ item for item in sorted(bag_of_words.items(), key=lambda x: x[1], reverse=True)]
print(top[:10:])








