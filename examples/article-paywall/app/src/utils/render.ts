import fs from 'fs';
import path from 'path';
import Markdoc from '@markdoc/markdoc';
import { createSSRApp, defineComponent } from 'vue'
import { renderToString } from 'vue/server-renderer'
import { unescape } from 'lodash';

const delimiter = '%%%';

// Note: This is just for demonstration purposes, use something like MDX
// instead if you're building a real app). You should probably not be using
// express.js and ejs either.

// Seriously, don't use this code in production.

// The expected article format is a markdown file with 3 sections separated by
// the delimiter:
// [meta]%%%[preview]%%%[paid]

function render(id: string, type: 'preview' | 'full' | 'paid') : Promise<string> | undefined {
  const articlePath = path.join(__dirname, '../../articles', id, 'index.md');
  const staticPath = path.join('/static', id);

  if (fs.existsSync(articlePath)) {

    const raw = fs.readFileSync(articlePath, 'utf8').split(delimiter);
    if (raw.length < 3) {
        throw new Error(`Invalid article format: ${id}`);
    }

    // Check if the user has access to the full article
    const [meta, preview, paid] = raw;
    let doc : string;
    if (type === 'full') {
        doc = preview + paid;
    } else if (type === 'paid') {
        doc = paid;
    } else {
        doc = preview;
    }

    // We're going to convert the Markdown file into a Vue component :)
    const ast = Markdoc.parse(doc);
    const content = Markdoc.transform(ast, {
        variables: { static: staticPath, }
    });
    const html = theme(Markdoc.renderers.html(content));
    const app = createSSRApp({ 
        setup() { return eval(meta); },
        components: {
            Image,
            Author,
            Fadeout,
        },
        template: unescape(html),
    })

    return renderToString(app);
  } else {
    return undefined;
  }
}

function theme(html: string) {

    // Add tailwind classes to <p> tags
    html = html.replace(/<p>/g, '<p class="text-gray-800 text-lg text-left mb-10 sm:text-justify">');
    html = html.replace(/<h2>/g, '<h2 class="text-2xl sm:text-3xl font-semibold tracking-tight text-gray-900 text-left mt-10 mb-5">');
    html = html.replace(/<h3>/g, '<h3 class="text-xl font-semibold tracking-tight text-gray-900 text-left mt-10 mb-5">');

    return html;
}

const Author = defineComponent({ 
    props:['name', 'date'],
    template: `
    <div class="text-lg -mb-5">
      <span class="text-gray-500">{{ date }} by</span>
      <span class="text-black">
        <a href="#" class="text-semibold ml-1">{{ name }}</a>
      </span>
    </div>
`});

const Image = defineComponent({
    props:['title', 'description', 'image', 'alt'],
    template: `
    <div class="mx-auto max-w-3xl mt-10">
      <div class="mb-10">
        <img :src="image" />
        <p class="text-gray-500 text-sm text-left mt-2">{{alt}}</p>
      </div>
    </div>
`});

const Fadeout = defineComponent({
    props:['text'],
    template: `
    <div id="faded-content" class="mb-10 fade-out-gradient">
      <p class="text-gray-800 text-lg text-left text-justify">
        {{ text}}
      </p>
    </div>
`});



export {
    render,
}