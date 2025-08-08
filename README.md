# 📰 Bangla News Text Analysis & Topic Modeling

[![Made with R](https://img.shields.io/badge/Made%20with-R-blue?style=for-the-badge&logo=r&logoColor=white)](https://www.r-project.org/)

## 📌 Objective
The goal of this project is to perform **complete text analysis** on Bangla news articles scraped from the NTV BD news portal.  
It demonstrates practical skills in:
- **Web scraping** Bangla news articles
- **Text preprocessing** for Bangla language
- **Visual analytics** (word frequency, word clouds, bar plots)
- **Topic modeling** with Latent Dirichlet Allocation (LDA)

---

## 🛠 Features
- **Web Scraping:** Extracted Bangla news article texts from multiple category pages on [NTV BD](https://www.ntvbd.com/).
- **Text Preprocessing:** Removed punctuation, digits, extra spaces, and common Bangla stopwords.
- **Word Frequency Analysis:** Visualized top words with **WordCloud** and frequency bar plots.
- **Topic Modeling (LDA):** Discovered hidden topics and visualized top words per topic.
- **Document–Topic Distribution:** Interpreted results with stacked bar plots for each article.

---

## 📊 Workflow
1. **Scraping** → Collect articles from NTV BD using `rvest`.
2. **Preprocessing** → Clean Bangla text for analysis.
3. **Word Frequency Analysis** → Generate word cloud & bar plots.
4. **Topic Modeling** → Apply LDA to discover topics.
5. **Visualization & Interpretation** → Topic distributions and insights.

---

## 🧰 Tech Stack
- **Language:** R
- **Libraries:**  
  - `rvest` – Web scraping  
  - `readr` – Reading data files  
  - `dplyr` – Data manipulation  
  - `purrr` – Functional programming tools  
  - `tidyr` – Data tidying  
  - `stringr` – String processing  
  - `tm` – Text mining  
  - `tokenizers` – Tokenization  
  - `wordcloud` – Word cloud generation  
  - `RColorBrewer` – Color palettes for visualizations  
  - `topicmodels` – LDA topic modeling  
  - `tidytext` – Text mining using tidy data principles  
  - `ggplot2` – Data visualization


---



## 🚀 How to Run
1. Clone the repo:
   ```bash
   git clone https://github.com/WasifAsad/Bangla-News-Text-Analysis.git
   cd bangla-news-text-analysis
2. Open the .R scripts or R Markdown files.

3. Install required libraries:
      ```bash
      install.packages(c("rvest", "readr", "dplyr", "purrr", "tidyr", "stringr","tm", "tokenizers", "wordcloud", "RColorBrewer","topicmodels", "tidytext", "ggplot2"))

4. Run script : Bangla-Text-Analysis.R

### N.B. :
- You can change your news portal by replacing the website in base_url.
- Also change the output directories (Word Cloud, .csv file, etc.) according to your own folder paths.
- Also you can add other Bangla stop words.


---


## 📸 Sample Outputs (For the specific day that we ran the code on)
### Word Cloud
<img width="1000" height="800" alt="wordcloud" src="https://github.com/user-attachments/assets/f9891888-9bbc-4870-98cf-7c0f1793717c" />

### Top Words Visualization per Topic
<img width="1000" height="800" alt="barplot_topic1" src="https://github.com/user-attachments/assets/552aa2fb-23ea-40ad-b25c-c13b52bcdeb6" />
<img width="1000" height="800" alt="barplot_topic2" src="https://github.com/user-attachments/assets/435ca58e-ba84-4e4b-90e8-19902dc757df" />
<img width="1000" height="800" alt="barplot_topic3" src="https://github.com/user-attachments/assets/804aac0e-56d9-4a26-9faf-09b6ed22c07c" />
<img width="1000" height="800" alt="barplot_topic4" src="https://github.com/user-attachments/assets/99c3f1e3-9a3d-4937-8c75-901014f2118a" />
<img width="1000" height="800" alt="barplot_topic5" src="https://github.com/user-attachments/assets/ddb5dbd3-abec-4414-8bc1-e7df75d97401" />



---


## 📜 License

This project is licensed under the MIT License. Feel free to use, modify, and distribute this project.


---


## 📧 Contact

For inquiries or support, feel free to reach out:  
    Authors:  
    Wasif Asad Alvi  
    Md. Tamjid Hossain  
    Rifat Talukdar  
    Md. Tanziul Haque  
    Email: [wasifasad35@gmail.com]  
    GitHub: <a href=https://github.com/WasifAsad>WasifAsad </a> 


