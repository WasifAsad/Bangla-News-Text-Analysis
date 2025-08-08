library(rvest)
library(readr)
library(dplyr)
library(purrr)
library(tidyr)
library(stringr)
library(tm)
library(tokenizers)
library(wordcloud)
library(RColorBrewer)
library(topicmodels)
library(tidytext)
library(ggplot2)


# Base URL
base_url <- "https://www.ntvbd.com/"

# Read homepage
homepage <- read_html(base_url)

# Extract tags
a_nodes <- homepage %>% html_nodes("h2 a, h3 a, h4 a")

# Get href and title
links_data <- data.frame(
  href = a_nodes %>% html_attr("href"),
  title = a_nodes %>% html_text(trim = TRUE),
  stringsAsFactors = FALSE
)

# Filter and clean
links_data <- links_data %>%
  filter(!is.na(href), title != "") %>%
  mutate(
    href = ifelse(grepl("^http", href), href, paste0(base_url, href))
  ) %>%
  distinct()

# File path
output_file <- "ntv_links_with_labels.csv"

# Write with UTF-8 to show Bangla
write_lines("\uFEFF", output_file)
write_csv(links_data, output_file, append = TRUE, col_names = TRUE)


# Load links from csv
article_links <- read_csv("ntv_links_with_labels.csv", show_col_types = FALSE)[1:60,]


# Function to extract article details
extract_article_details <- function(url) {
  tryCatch({
    page <- read_html(url)
    closeAllConnections()
    Sys.sleep(1)
    
    # Extract text from all <p> tags
    panel_nodes <- page %>% html_nodes("div.tabs-panel.is-active")
    if (length(panel_nodes) > 0) {
      xml2::xml_remove(panel_nodes)
    }
    
    paragraphs <- page %>%
      html_nodes("p") %>%
      html_text() %>%
      paste(collapse = " ")  # Combine all text into one single string
    
    return(data.frame(
      article_text = paragraphs,
      stringsAsFactors = FALSE
    ))
  }, error = function(e) {
    message("Failed to scrape: ", url)
    return(data.frame(
      article_text = NA,
      stringsAsFactors = FALSE
    ))
  })
}

# Loop through all links and extract details
results <- article_links %>%
  mutate(full_url = href) %>%
  mutate(scraped = map(full_url, extract_article_details)) %>%
  unnest(scraped) %>%
  select(full_url, article_text)

# File path
output_file <- "ntv_article_texts.csv"

# Write with UTF-8 to show Bangla
write_lines("\uFEFF", output_file)
write_csv(results, output_file, append = TRUE, col_names = TRUE)


# Load article text
text_data <- read_csv("ntv_article_texts.csv")
article_text <- text_data$article_text

# Bangla stopwords
bangla_stopwords <- c("এবং","ও","এ" , "বলেন",  "এক",  "দুই", "তিন", "চার", "পাঁচ","ছয়", "সাত", "আট", "নয়" , "থেকে", "করে", "জন্য", "করা",
                      "হবে", "হতে", "এর", "মধ্যে","পর","আরও", "ড" , "করার", "আর",  "করেছে",  "বা",   "এই", "কিন্তু", "ছিল", "হয়", "না", "তবে",
                      "যে", "তাদের", "আমাদের", "আপনার", "তিনি", "সে", "তাঁর", "দিয়ে", "একটি", "অনেক", "সব","সঙ্গে","নিয়ে","করেন" , "হয়েছে", "ছিলেন", "বলেছে")

# Text cleaning
cleaned_articles <- article_text %>%
  str_replace_all("[[:punct:]]", " ") %>%                     
  str_replace_all("[[:digit:]]", " ") %>%                 
  str_replace_all("\\b[a-zA-Z]+\\b", " ") %>%                 
  str_replace_all("\\s+", " ") %>%                            
  str_remove_all(paste0("\\b(", paste(bangla_stopwords, collapse = "|"), ")\\b"))  

print(substr(cleaned_articles, 1, 500))

#Corpus
corpus <- Corpus(VectorSource(cleaned_articles))

# tokenization
tokens <- tokenize_words(cleaned_articles)
print(tokens)

# DocumentTermMatrix
dtm <- DocumentTermMatrix(corpus)
print(dtm)

# DTM matrix and word frequency
m <- as.matrix(dtm)
row_totals <- rowSums(m)
dtm_filtered <- dtm[row_totals > 0, ]
m_filtered <- as.matrix(dtm_filtered)
word_freqs <- sort(colSums(m_filtered), decreasing = TRUE)
df <- data.frame(word = names(word_freqs), freq = word_freqs)
head(df)

# Word cloud
# Save word cloud to a PNG file
png("wordcloud.png", width = 1000, height = 800)
set.seed(123)
wordcloud(words = df$word,
          freq = df$freq,
          min.freq = 3,
          max.words = 100,
          random.order = FALSE,
          colors = brewer.pal(8, "Dark2"))
dev.off()

top_20 <- df %>% top_n(20, wt = freq)
print(top_20)

# Save to PNG file
png("top_words_plot.png", width = 1000, height = 800)

# Plot inside the PNG file
barplot(
  top_20$freq,
  main = "Top 20 Most Frequent Words",
  names.arg = top_20$word,
  col = "blue",
  las = 2,
  xlab = "Words",
  ylab = "Frequency")
dev.off()

# Topic Modeling with LDA
num_topics <- 5
lda_model <- LDA(dtm_filtered, k = num_topics, control = list(seed = 58))

# Top terms per topic
top_terms <- terms(lda_model, 10)
print(top_terms)

# Get top 10 words of topic 1
topic_num <- 1
words_topic <- top_terms[, topic_num]

# Frequency from Data Frame 
freqs_topic <- df$freq[match(words_topic, df$word)]

# Replace NAs with 0 
freqs_topic[is.na(freqs_topic)] <- 0


# Barplot
png("barplot_topic1.png", width = 1000, height = 800)
barplot(freqs_topic,
        names.arg = words_topic,
        main = paste("Top words in Topic", topic_num),
        col = "skyblue",
        las = 2, 
        ylab = "Frequency",
        cex.names = 1.2,
        border = "black")
dev.off()

# Get top 10 words of topic 2
topic_num <- 2
words_topic <- top_terms[, topic_num]

# Frequency from Data Frame 
freqs_topic <- df$freq[match(words_topic, df$word)]

# Replace NAs with 0
freqs_topic[is.na(freqs_topic)] <- 0

# Barplot
png("barplot_topic2.png", width = 1000, height = 800)
barplot(freqs_topic,
        names.arg = words_topic,
        main = paste("Top words in Topic", topic_num),
        col = "skyblue",
        las = 2,     
        ylab = "Frequency",
        cex.names = 1.2,
        border = "black")
dev.off()

# Get top 10 words of topic 3
topic_num <- 3
words_topic <- top_terms[, topic_num]

# Frequency from Data Frame 
freqs_topic <- df$freq[match(words_topic, df$word)]

# Replace NAs with 0 
freqs_topic[is.na(freqs_topic)] <- 0

# Barplot
png("barplot_topic3.png", width = 1000, height = 800)
barplot(freqs_topic,
        names.arg = words_topic,
        main = paste("Top words in Topic", topic_num),
        col = "skyblue",
        las = 2,          
        ylab = "Frequency",
        cex.names = 1.2,
        border = "black")
dev.off()

# Get top 10 words of topic 4
topic_num <- 4
words_topic <- top_terms[, topic_num]

# Frequency from Data Frame 
freqs_topic <- df$freq[match(words_topic, df$word)]

# Replace NAs with 0 
freqs_topic[is.na(freqs_topic)] <- 0

# Barplot
png("barplot_topic4.png", width = 1000, height = 800)
barplot(freqs_topic,
        names.arg = words_topic,
        main = paste("Top words in Topic", topic_num),
        col = "skyblue",
        las = 2,             
        ylab = "Frequency",
        cex.names = 1.2,
        border = "black")
dev.off()

# Get top 10 words of topic 5
topic_num <- 5
words_topic <- top_terms[, topic_num]

# Frequency from Data Frame 
freqs_topic <- df$freq[match(words_topic, df$word)]

# Replace NAs with 0 
freqs_topic[is.na(freqs_topic)] <- 0

# Barplot
png("barplot_topic5.png", width = 1000, height = 800)
barplot(freqs_topic,
        names.arg = words_topic,
        main = paste("Top words in Topic", topic_num),
        col = "skyblue",
        las = 2,             
        ylab = "Frequency",
        cex.names = 1.2,
        border = "black")
dev.off()


# Document-topic probabilities using tidytext
doc_topics <- tidy(lda_model, matrix = "gamma")  

# View a sample
head(doc_topics)

# Sort Documents and Label Topic
doc_topics <- doc_topics %>%
  mutate(document = factor(as.integer(document), levels = sort(unique(as.integer(document)))),
         topic = paste("Topic", topic))

# Plot Stacked bar chart
png("Document–Topic Distribution.png", width = 1000, height = 800)
ggplot(doc_topics, aes(x = factor(document), y = gamma, fill = topic)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Document–Topic Distribution",
    x = "Document",
    y = "Topic Probability",
    fill = "Topic"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90))
dev.off()


