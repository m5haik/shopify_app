import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Read the Orders and Shipping reviews datset
df = pd.read_csv("Results/reviews_dataset.csv")

# pd.set_option('display.max_columns', None)
# Separating reviews into positive, negative or neutral reviews

positive_reviews = df[df['review_rating'] > 3]
negative_reviews = df[df['review_rating'] < 3]
neutral_reviews = df[df['review_rating'] == 3]

pos_text = " ".join(str(review) for review in positive_reviews.comment)
neg_text = " ".join(str(review) for review in negative_reviews.comment)
neu_text = " ".join(str(review) for review in positive_reviews.comment)

# Creating a word cloud image:
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator

# Create stopword list:
stopwords1 = set(STOPWORDS)
stopwords1.update(["app", "use", "love", "amazing", "great", "really", "best",
"thank", "make", "Thanks", "recommend", "recommended", "Shopify"])

wordcloud1 = WordCloud(width=800, height=800, max_words=100, stopwords=stopwords1,
background_color="white").generate(pos_text)

wordcloud1.to_file("Results/positive_reviews.png")

# for negative reviews
stopwords2 = set(STOPWORDS)
stopwords2.update(["app", "need", "well", "say", "Shopify", "make", "will", "go",
"give", "know", "take", "going", "see"])

wordcloud2 = WordCloud(width=800, height=800, max_words=100, stopwords=stopwords2,
background_color="white").generate(neg_text)

wordcloud2.to_file("Results/negative_reviews.png")

# for neutral reviews
stopwords3 = set(STOPWORDS)
stopwords3.update(["app", "need", "well", "say", "Shopify", "make", "will", "go",
"give", "know", "take", "going", "see" ])

wordcloud3 = WordCloud(width=800, height=800, max_words=100, stopwords=stopwords3,
background_color="white").generate(neu_text)

wordcloud3.to_file("Results/neutral_reviews.png")
