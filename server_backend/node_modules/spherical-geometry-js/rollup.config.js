/** @type {import("rollup").RollupWatchOptions} */
const config = {
    input: 'src/index.js',
    output: { file: 'cjs.js', format: 'cjs', sourcemap: true },
};

export default config;
