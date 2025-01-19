import csv
from collections import defaultdict
from gensim import corpora
import os

def load_data(dataset_name, split='train'):
    """Load the dataset and prepare the corpus."""
    base_path = '/app/data'
    data_path = f'{base_path}/{dataset_name}_{split}/csv2/{dataset_name}_{split}.csv'
    vocab_path = f'{base_path}/{dataset_name}_train/csv2/{dataset_name}_vocab_mallet.csv'
    
    print(f"Loading data from: {data_path}")
    print(f"Loading vocabulary from: {vocab_path}")
    
    corpus = []
    mallet_dictionary = {}
    doc_freq = defaultdict(int)
    current_doc_id = None
    
    # Load document data
    with open(data_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        next(reader)
        for row in reader:
            docId, pos, wordId = row
            if current_doc_id != docId:
                if current_doc_id is not None:
                    corpus.append(list(doc_freq.items()))
                doc_freq = defaultdict(int)
                current_doc_id = docId
            doc_freq[int(wordId)] += 1
            
        if doc_freq:
            corpus.append(list(doc_freq.items()))

    # Load vocabulary
    with open(vocab_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        next(reader)
        for idx, row in enumerate(reader):
            word = row[0]
            mallet_dictionary[idx] = word
    
    # Create Gensim dictionary
    gensim_dictionary = corpora.Dictionary.from_corpus(corpus, id2word=mallet_dictionary)
    
    return corpus, gensim_dictionary 