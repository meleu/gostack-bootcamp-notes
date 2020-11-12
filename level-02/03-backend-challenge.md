# Challenge 6

- challenge: <https://github.com/rocketseat-education/bootcamp-gostack-desafios/tree/master/desafio-database-upload>
- solution: <https://www.youtube.com/watch?v=aEUDRBBbo-Y>

## Random Notes

Order:
```
create the databases (one for practice, and one for the unit tests)
migrations
models
[repository]
routes
services (business rules)
tests with insomnia
```

Differences between `transactionRepository.delete()` and `transactionRepository.remove()`.

## Migrations

`transactions` Data Base table:
- id
- title
- value
- type
- category_id (fk categories:id)
- created_at
- updated_at

For `category_id`, it's related to the `categories` table:
- id
- title (no repeat)
- created_at
- updated_at


## Importing CSV Files

I must understand every single line of code here:
```ts
import { getCustomRepository, getRepository, In } from 'typeorm';
import csvParse from 'csv-parse';
import fs from 'fs';

import Transaction from '../models/Transaction';
import Category from '../models/Category';

import TransactionsRepository from '../repositories/TransactionsRepository';

interface Request {
  filePath: string;
}

interface CSVTrasaction {
  title: string;
  value: number;
  type: 'income' | 'outcome';
  category: string;
}

class ImportTransactionsService {
  async execute({ filePath }: Request): Promise<Transaction[]> {
    const transactionsRepository = getCustomRepository(TransactionsRepository);
    const categoriesRepository = getRepository(Category);

    const readCSVStream = fs.createReadStream(filePath);

    const parseStream = csvParse({
      from_line: 2,
    });

    const parseCSV = readCSVStream.pipe(parseStream);

    const transactions: CSVTrasaction[] = [];
    const categories: string[] = [];

    parseCSV.on('data', line => {
      const [title, type, value, category] = line.map((item: string) =>
        item.trim(),
      );

      if (!title || !type || !value) return;

      categories.push(category);

      transactions.push({
        title,
        type,
        value,
        category,
      });
    });

    await new Promise(resolve => {
      parseCSV.on('end', resolve);
    });

    const categoriesExists = await categoriesRepository.find({
      where: { title: In(categories) },
    });

    const categoriesExistsTitles = categoriesExists.map(
      (category: Category) => category.title,
    );

    const addCategoryTitles = categories
      .filter(category => !categoriesExistsTitles.includes(category))
      .filter((value, index, self) => self.indexOf(value) === index);

    const newCategories = categoriesRepository.create(
      addCategoryTitles.map(title => ({
        title,
      })),
    );

    await categoriesRepository.save(newCategories);

    const finalCategories = [...newCategories, ...categoriesExists];

    const createdTransactions = transactionsRepository.create(
      transactions.map(transaction => ({
        title: transaction.title,
        type: transaction.type,
        value: transaction.value,
        category: finalCategories.find(
          category => category.title === transaction.category,
        ),
      })),
    );

    await transactionsRepository.save(createdTransactions);

    await fs.promises.unlink(filePath);

    return createdTransactions;
  }
}
```
