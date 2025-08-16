// Migrated from .eslintrc.js to eslint.config.js for ESLint v9+
import importPlugin from "eslint-plugin-import";
import typescriptPlugin from "@typescript-eslint/eslint-plugin";
import typescriptParser from "@typescript-eslint/parser";

export default [
  {
    files: ["src/**/*.ts", "src/**/*.js"],
    ignores: ["/lib/**/*", "/generated/**/*"],
    languageOptions: {
      parser: typescriptParser,
      parserOptions: {
        project: ["tsconfig.json", "tsconfig.dev.json"],
        sourceType: "module",
        ecmaVersion: 2020,
      },
      ecmaVersion: 2020,
      sourceType: "module",
      globals: {
        require: "readonly",
        module: "readonly",
        __dirname: "readonly",
        process: "readonly",
      },
    },
    plugins: {
      import: importPlugin,
      "@typescript-eslint": typescriptPlugin,
    },
    rules: {
      quotes: ["error", "double"],
      "import/no-unresolved": 0,
      indent: ["error", 2],
      "quote-props": ["error", "consistent-as-needed"],
    },
  },
];
