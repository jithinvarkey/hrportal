<?php

declare(strict_types=1);

namespace App\Services;

class AnnualLeaveCarryForwardPolicy
{
    public const MAX_DAYS = 10.0;

    public function calculate(bool $enabled, float $remainingDays, float|int|null $configuredMaximum = null): float
    {
        if (! $enabled || $remainingDays <= 0) {
            return 0.0;
        }

        $configuredMaximum = (float) $configuredMaximum;
        $limit = $configuredMaximum > 0
            ? min($configuredMaximum, self::MAX_DAYS)
            : self::MAX_DAYS;

        return round(min($remainingDays, $limit), 2);
    }

    public function preserveExisting(float $existingDays, float $calculatedDays): float
    {
        return $existingDays > 0 ? $existingDays : $calculatedDays;
    }
}
