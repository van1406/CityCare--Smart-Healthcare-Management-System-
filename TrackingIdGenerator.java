package com.citycare.util;

import java.time.Year;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Utility to generate unique tracking IDs for complaints (e.g. CC-2026-78412).
 */
public class TrackingIdGenerator {

    public static String generateTrackingId() {
        int currentYear = Year.now().getValue();
        int randomDigits = ThreadLocalRandom.current().nextInt(10000, 99999);
        return "CC-" + currentYear + "-" + randomDigits;
    }
}

