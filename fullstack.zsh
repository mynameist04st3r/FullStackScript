#!/bin/zsh

brew update
brew upgrade

npm install -g npm-check-updates

while true; do
  echo -n "Enter the project name: "
  read name
  if [ ! -d ~/SOFDevProjects/$name ]; then
    mkdir ~/SOFDevProjects/$name
    break
  else
    echo "Project directory $name already exists. Please choose a different name."
  fi
done
cd ~/SOFDevProjects/$name
git init
mkdir server
cd server
npm init -y
npm install knex --save
npm i pg express nodemon cors
npx knex init
touch server.js
echo "const port = 8000;
const express = require('express');
const app = express();
const knex = require('knex')(require('./knexfile.js')['development']);
app.get('/', (req, res) => {
  res.send('Here it is.');
})
app.get('/DATABASE_NAME', (req, res) => {
  knex('DATABASE_NAME').select('*').then(DATABASE_HEADER => {
    let VARIABLE = DATABASE_HEADER.map(DATABASE_NAME => DATABASE_NAME.DATABASE_HEADER)
    res.json(VARIABLE);
  })
});
app.listen(port, () => {
  console.log('Server running at http://localhost: ' + port);
});" > server.js

node -e '
  const knexfile = require("./knexfile");
  knexfile.development.client = "pg";
  knexfile.development.connection = {
    host: "127.0.0.1",
    password: "docker",
    user: "postgres",
    port: 5432,
    database: "PUT DATABASE NAME HERE"
  };
  let output = "module.exports = {\n";
  output += "  development: {\n";
  output += "    client: \"pg\",\n";
  output += "    connection: {\n";
  output += "      host: \"127.0.0.1\",\n";
  output += "      user: \"postgres\",\n";
  output += "      password: \"docker\",\n";
  output += "      port: 5432,\n";
  output += "      database: \"PUT DATABASE NAME HERE\"\n";
  output += "    }\n";
  output += "  },\n";
  output += "  staging: {\n";
  output += "    client: \"postgresql\",\n";
  output += "    connection: {\n";
  output += "      database: \"my_db\",\n";
  output += "      user: \"username\",\n";
  output += "      password: \"password\"\n";
  output += "    },\n";
  output += "    pool: {\n";
  output += "      min: 2,\n";
  output += "      max: 10\n";
  output += "    },\n";
  output += "    migrations: {\n";
  output += "      tableName: \"knex_migrations\"\n";
  output += "    }\n";
  output += "  },\n";
  output += "  production: {\n";
  output += "    client: \"postgresql\",\n";
  output += "    connection: {\n";
  output += "      database: \"my_db\",\n";
  output += "      user: \"username\",\n";
  output += "      password: \"password\"\n";
  output += "    },\n";
  output += "    pool: {\n";
  output += "      min: 2,\n";
  output += "      max: 10\n";
  output += "    },\n";
  output += "    migrations: {\n";
  output += "      tableName: \"knex_migrations\"\n";
  output += "    }\n";
  output += "  }\n";
  output += "}\n";
  console.log(output);
' > temp.js && mv temp.js knexfile.js

cd ..
npm create vite@latest client -- --template react -y
cd client
npm install

npm install --save-dev vitest jsdom @testing-library/react @testing-library/jest-dom
mkdir tests
touch tests/setupTests.js
echo "import \"@testing-library/jest-dom/vitest\";" >> tests/setupTests.js

node -e '
  const packageJson = require("./package.json");
  const scripts = Object.keys(packageJson.scripts).map(key => ({ [key]: packageJson.scripts[key] }));
  scripts.push({ start: "vite" });
  scripts.push({ test: "vitest" });
  const index = scripts.findIndex(script => script.dev);
  if (index >= 0) {
    scripts.splice(index, 1);
  }
  packageJson.scripts = Object.assign({}, ...scripts);
  const fs = require("fs");
  fs.writeFileSync("package.json", JSON.stringify(packageJson, null, 2));
'

node -e '
  const fs = require("fs");
  const viteConfig = fs.readFileSync("vite.config.js", "utf8");
  const lines = viteConfig.split("\n");
  const newConfig = [];
  let inDefineConfig = false;
  for (const line of lines) {
    if (line.includes("export default defineConfig(")) {
      inDefineConfig = true;
    }
    if (inDefineConfig) {
      if (line.includes("plugins: [react()],")) {
        newConfig.push(line);
        newConfig.push("  test: {");
        newConfig.push("    globals: true,");
        newConfig.push("    environment: \"jsdom\",");
        newConfig.push("    setupFiles: \"./tests/setupTests.js\",");
        newConfig.push("  },");
      } else {
        newConfig.push(line);
      }
    } else {
      newConfig.push(line);
    }
  }
  fs.writeFileSync("vite.config.js", newConfig.join("\n"));
'

touch src/App.test.jsx

npm install react-router-dom
npm install @mui/material @mui/icons-material @emotion/react @emotion/styled
npm install --save chroma-js

cp .gitignore ../server/.gitignore

cd ..

code .
