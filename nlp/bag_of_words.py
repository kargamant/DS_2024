stop_words = []
with open("stop_words.txt", 'r') as file:
    stop_words = file.read().split('\n')
print(stop_words)
content = ''
with open('yoyodine_bank_review.txt', 'r') as file:
    content = file.read().replace('\n', ' ').replace('!', '').replace('?', '').replace(',', '').replace('.', '').lower().split(' ')
content.remove('')
print(content, end='\n\n')

# removing stop words
for st in stop_words:
    if st in content:
        content = list(filter(lambda x: x!=st, content))
print(content, end='\n\n')

bag_of_words = {}
for w in content:
    bag_of_words[w] = 0

for w in content:
    bag_of_words[w]+=1

print(bag_of_words)
