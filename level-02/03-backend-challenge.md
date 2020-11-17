# Challenge 6

- challenge: <https://github.com/rocketseat-education/bootcamp-gostack-desafios/tree/master/desafio-database-upload>
- solution: <https://www.youtube.com/watch?v=aEUDRBBbo-Y>


## Random Notes

- Order:
```
create the databases (one for practice, and one for the unit tests)
migrations
models
[repository]
routes
services (business rules)
tests with insomnia
```

- I need a better understanding of the differences between `transactionRepository.delete()` and `transactionRepository.remove()`.

- Importing CSV Files
  - use `multer` to get the csv file
  - use `csv-parser` to parse the file
  - bulk save the contents of the file in the database

- short and useful video showing how to parse csv with `csv-parser`: <https://www.youtube.com/watch?v=9_x-UIVlxgo>
```js
const parse = require('csv-parse');
const fs = require('fs');

const csvData = [];

fs.createReadStream(__dirname + '/test.csv')
  .pipe(
    parse({
      delimiter: ','
    })
  )
  .on('data', (dataRow) => csvData.push(dataRow))
  .on('end', () => console.log(csvData));
```

- Cleaning up the solution. I'm not really happy with my code [here](https://github.com/meleu/gostack-desafio-6/blob/master/src/services/ImportTransactionsService.ts), it's kinda messy.
