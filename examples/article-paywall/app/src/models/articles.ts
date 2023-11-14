import path from 'path';
import fs from 'fs';
import { CurrencyCode } from '@code-wallet/library';
import { render } from '../utils/render';

const defaultCurrency: CurrencyCode = 'usd';
const defaultPrice = 0.25;

export interface Article {
  id: string;
  price: number;
  currency: CurrencyCode;
}

// You should use a database instead of an in-memory object. This is just for
// demonstration purposes.
const articles: { [key: string]: Article } = {};

export const loadArticles = () => {
  // Find all articles inside the ./articles folder. Each article is a folder
  // containing a markdown file and static assets referenced by the markdown
  // file.

  // For each article, generate a unique id and store it in the articles object.
  // We're going to assume all articles are the same cost.
  const articleIds = fs.readdirSync(path.join(__dirname, '../../articles'), {
    withFileTypes: true,
  });

  articleIds.forEach((entry:any) => {
    if (!entry.isDirectory()) {
      return;
    }
    const id = entry.name;
    articles[id] = {
      id,
      price: defaultPrice,
      currency: defaultCurrency,
    };
  });

  return articles;
};

export const filterArticles = (filter: (item: Article) => boolean): Article | undefined => {
    return Object.values(articles).find(filter);
};

export const findArticle = (props: Partial<Article>): Article | undefined => {
    return filterArticles((item) => {
        return Object.entries(props).every(([key, value]) => {
            return item[key as keyof Article] === value;
        });
    });
};

export const getArticleById = (id: string): Article | undefined => {
  return articles[id];
};

export const getFirstArticle = (): Article | undefined => {
  return Object.values(articles)[0];
}

export const getArticleContent = async (id: string, type: 'preview' | 'full' | 'paid') => {
  return render(id, type);
}
