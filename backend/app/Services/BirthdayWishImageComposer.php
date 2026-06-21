<?php

namespace App\Services;

use RuntimeException;

class BirthdayWishImageComposer
{
    private const WIDTH = 1200;

    public function compose(string $sourcePath, string $message): string
    {
        $source = $this->openImage($sourcePath);
        $sourceWidth = imagesx($source);
        $sourceHeight = imagesy($source);
        $height = max(1, (int) round(self::WIDTH * $sourceHeight / $sourceWidth));

        $canvas = imagecreatetruecolor(self::WIDTH, $height);
        $white = imagecolorallocate($canvas, 255, 255, 255);
        imagefill($canvas, 0, 0, $white);
        imagecopyresampled($canvas, $source, 0, 0, 0, 0, self::WIDTH, $height, $sourceWidth, $sourceHeight);
        imagedestroy($source);

        $font = $this->fontPath();
        $fontSize = 34;
        $lineHeight = 50;
        $lines = $this->wrap($message, $font, $fontSize, self::WIDTH - 170);
        if (count($lines) > 12) {
            $fontSize = 27;
            $lineHeight = 41;
            $lines = $this->wrap($message, $font, $fontSize, self::WIDTH - 170);
        }

        $panelTop = 50;
        $panelHeight = min($height - 100, max(130, count($lines) * $lineHeight + 70));
        $panel = imagecolorallocatealpha($canvas, 255, 255, 255, 22);
        imagefilledrectangle($canvas, 50, $panelTop, self::WIDTH - 50, $panelTop + $panelHeight, $panel);

        $textColor = imagecolorallocate($canvas, 31, 41, 55);
        $y = $panelTop + 58;
        foreach ($lines as $line) {
            if ($y > $panelTop + $panelHeight - 20) break;
            imagettftext($canvas, $fontSize, 0, 85, $y, $textColor, $font, $line);
            $y += $lineHeight;
        }

        $directory = storage_path('app/birthday-wish-renders');
        if (!is_dir($directory) && !mkdir($directory, 0775, true) && !is_dir($directory)) {
            throw new RuntimeException('Unable to create the birthday image render directory.');
        }
        $output = $directory . DIRECTORY_SEPARATOR . uniqid('birthday-', true) . '.jpg';
        if (!imagejpeg($canvas, $output, 90)) {
            imagedestroy($canvas);
            throw new RuntimeException('Unable to render the birthday email image.');
        }
        imagedestroy($canvas);

        return $output;
    }

    private function openImage(string $path)
    {
        $mime = mime_content_type($path);
        $image = match ($mime) {
            'image/jpeg' => imagecreatefromjpeg($path),
            'image/png' => imagecreatefrompng($path),
            'image/webp' => imagecreatefromwebp($path),
            default => false,
        };
        if (!$image) throw new RuntimeException('The birthday background image could not be opened.');
        return $image;
    }

    private function fontPath(): string
    {
        foreach ([
            'C:\\Windows\\Fonts\\arial.ttf',
            '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
            '/usr/share/fonts/dejavu/DejaVuSans.ttf',
        ] as $font) {
            if (is_file($font)) return $font;
        }
        throw new RuntimeException('No supported TrueType font was found for birthday email rendering.');
    }

    private function wrap(string $message, string $font, int $size, int $maxWidth): array
    {
        $result = [];
        foreach (preg_split('/\R/u', $message) as $paragraph) {
            if (trim($paragraph) === '') {
                $result[] = '';
                continue;
            }
            $line = '';
            foreach (preg_split('/\s+/u', trim($paragraph)) as $word) {
                $candidate = $line === '' ? $word : $line . ' ' . $word;
                $box = imagettfbbox($size, 0, $font, $candidate);
                if ($line !== '' && abs($box[2] - $box[0]) > $maxWidth) {
                    $result[] = $line;
                    $line = $word;
                } else {
                    $line = $candidate;
                }
            }
            $result[] = $line;
        }
        return $result;
    }
}
