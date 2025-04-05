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

open /Applications/Docker.app

cd ~/SOFDevProjects/$name
git init
mkdir server
cd server
npm init -y
npm install knex --save
npm i pg express nodemon cors express-session uuid
npm install @uswriting/bcrypt
npm install @faker-js/faker
npx knex init
mkdir src
touch src/index.js
touch src/auth.js
mkdir images
echo "const port = 8000;
const express = require('express');
const app = express();
const knex = require('knex')(require('./knexfile.js')['development']);
app.get('/', (req, res) => {
  res.send('Server Operational.');
})
app.get('/$name', (req, res) => {
  knex('$name').select('*').then(DATABASE_HEADER => {
    let VARIABLE = DATABASE_HEADER.map($name => $name.DATABASE_HEADER)
    res.json(VARIABLE);
  })
});
app.listen(port, () => {
  console.log('Server running at http://localhost:' + port);
});" > index.js

node -e '
  const packageJson = require("./package.json");
  const scripts = Object.keys(packageJson.scripts).map(key => ({ [key]: packageJson.scripts[key] }));
  scripts.push({ start: "nodemon index.js" });
  const index = scripts.findIndex(script => script.dev);
  if (index >= 0) {
    scripts.splice(index, 1);
  }
  packageJson.scripts = Object.assign({}, ...scripts);
  const fs = require("fs");
  fs.writeFileSync("package.json", JSON.stringify(packageJson, null, 2));
'

node -e '
  const knexfile = require("./knexfile");
  knexfile.development.client = "pg";
  knexfile.development.connection = {
    host: "127.0.0.1",
    password: "docker",
    user: "postgres",
    port: 5432,
    database: "'$name'"
  };
  let output = "module.exports = {\n";
  output += "  development: {\n";
  output += "    client: \"pg\",\n";
  output += "    connection: {\n";
  output += "      host: \"127.0.0.1\",\n";
  output += "      user: \"postgres\",\n";
  output += "      password: \"docker\",\n";
  output += "      port: 5432,\n";
  output += "      database: \"'$name'\"\n";
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

docker pull postgres
mkdir -p $HOME/docker/volumes/postgres
container_id=$(docker run --rm --name $name -e POSTGRES_PASSWORD=docker -dp 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data postgres)

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
mkdir fonts
mkdir src/components
mkdir src/styles
mv src/App.css src/styles/App.css
mv src/index.css src/styles/index.css
touch tests/App.test.jsx

npm install react-router-dom
npm install @mui/material @mui/icons-material @emotion/react @emotion/styled
npm install --save chroma-js
npm install axios

cp .gitignore ../server/.gitignore

cd ..

mv client/README.md README.md

code .

# docker exec -it $name bash
# psql -U postgres
# CREATE DATABASE $name;

# The above code doesn't work quite right. Will try the following code later:

docker exec -it $name psql -U postgres -c "CREATE DATABASE $name;"
