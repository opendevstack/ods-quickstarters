import { createHash } from 'crypto';
import { writeFile } from 'fs/promises';
import * as sharp from 'sharp';
import { ScreenshotEvidenceData, ScreenshotEvidenceResult } from './screenshot.types';

const SCREENSHOT_METADATA = {
  height: 50,
  margin: 10,
  textAlign: 'left',
  textColor: '#000',
  textSize: 'large',
  backgroundColor: '#fff',
  maxNameLength: 100,
} as const;
const EVIDENCE_HASH_ALGORITHM = 'sha256' as const;

export const addEvidenceMetaToScreenshot = async (data: ScreenshotEvidenceData): Promise<ScreenshotEvidenceResult> => {
  const metadata: [string, string][] = [
    ['Timestamp', data.takenAt],
    ['Testname', data.name.substring(0, SCREENSHOT_METADATA.maxNameLength)],
    ['Step', data.step.toString()],
    ['Screenshot', data.subStep.toString()],
    ['Build number', process.env.BUILD_NUMBER ?? '-'],
    ['Git commit', process.env.COMMIT_INFO_SHA ?? '-'],
  ];

  const image = sharp(data.path);
  const imageMetadata = await image.metadata();
  const imageBuffer = await image
    .resize({
      background: SCREENSHOT_METADATA.backgroundColor,
      fit: 'contain',
      height: (imageMetadata.height ?? 0) + SCREENSHOT_METADATA.height,
      position: 'bottom',
      width: imageMetadata.width ?? 0,
    })
    .composite([
      {
        input: {
          text: {
            align: SCREENSHOT_METADATA.textAlign,
            rgba: true,
            text: metadata
              .map(([key, value]) => `<span foreground="${SCREENSHOT_METADATA.textColor}" size="${SCREENSHOT_METADATA.textSize}"><b>${key}</b>: ${value}</span>`)
              .join('\t'),
            width: (imageMetadata.width ?? 0) - SCREENSHOT_METADATA.margin * 2,
          },
        },
        left: SCREENSHOT_METADATA.margin,
        top: SCREENSHOT_METADATA.margin,
      },
    ])
    .toBuffer();
  await writeFile(data.path, imageBuffer);

  const hash = createHash(EVIDENCE_HASH_ALGORITHM).update(imageBuffer).digest('hex');
  return {
    hash,
    path: data.path,
  }
};
