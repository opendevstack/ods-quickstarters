import * as puppeteer from 'puppeteer';
import * as path from 'path';
import * as fs from 'fs';

async function expandReportTestCases(htmlPage: puppeteer.Page) {
  await htmlPage.evaluate(() => {
    const expandTestHeaders = document.querySelectorAll('[class^="test--header"], [class*="test--header"]');
    for (const testHeader of Array.from(expandTestHeaders)) {
      (testHeader as HTMLElement).click();
    }
  });
}

const isLocal = process.env.NODE_ENV === 'local';

(async () => {
  try {
    const files = await fs.promises.readdir('build/test-results/mochawesome/');

    for (const file of files) {

      if (!fs.existsSync(path.resolve(__dirname, 'build/test-results/mochawesome/', 'pdf')))
        fs.mkdirSync(path.resolve(__dirname, 'build/test-results/mochawesome/', 'pdf'));
      if (!file.endsWith('.html')) {
        continue;
      }

      const executablePath = isLocal ? undefined : '/usr/bin/google-chrome';

      const browser = await puppeteer.launch({ args: ['--no-sandbox'],
        executablePath
      });
      const page = await browser.newPage();
      const htmlFullFilePath = path.resolve(__dirname, 'build/test-results/mochawesome/', file);

      await page.goto(`file://${htmlFullFilePath}`, { waitUntil: 'networkidle2' });

      await expandReportTestCases(page);

      const images = await page.$$('img');
      for (const image of images) {
        await page.waitForFunction((img) => img.complete && img.naturalHeight !== 0, {}, image);
      }

      await page.addStyleTag({
        content: `
                @media print {
                  [class*="navbar"] {
                    position: static !important;
                  }
                }
              `
      });

      await page.pdf({
        path: path.resolve(__dirname, 'build/test-results/mochawesome/', 'pdf/', file.replace('.html', '.pdf')),
        format: 'A4',
        printBackground: true,
      });
      await browser.close();
    }

    console.log('PDF files generated successfully');

  } catch (error) {
    console.error('Error generating PDF:', error);
  }
})();
