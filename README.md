# aero-scan

**aero-scan** is a Bash script that reads live aircraft data from a local [dump1090](https://github.com/flightaware/dump1090) ADS-B decoder, formats a table of current flights overhead, and emails you a clean flight report.

---

## Features

* Parses and summarizes ADS-B aircraft data from JSON output
* Identifies major airlines and private/general aviation by callsign
* Outputs a readable, aligned table with flight info (callsign, airline, altitude, speed, position, RSSI)
* Can be scheduled via cron for daily/automated reports
* Easily customizable airline lookup and report formatting

---

## Prerequisites

* [dump1090](https://github.com/flightaware/dump1090) (or similar) running and writing `aircraft.json`
* [`jq`](https://stedolan.github.io/jq/) installed for JSON parsing
* `mail` (or `mailx`) installed for sending emails
* Bash (script tested on Linux)

---

## Usage

1. **Set your paths and email:**
   Edit the script and update these lines:

   ```bash
   JSON_FILE="/path/to/aircraft.json"
   EMAIL_TO="your_email@example.com"
   ```

2. **Make the script executable:**

   ```bash
   chmod +x aero-scan.sh
   ```

3. **Run manually:**

   ```bash
   ./aero-scan.sh
   ```

4. **Or schedule with `cron`:**

   ```bash
   crontab -e
   # Example: every day at 7am
   0 7 * * * /full/path/to/aero-scan.sh
   ```

---

## Example Output

```
✈️  Aero-Scan Report – 2025-07-25 20:04:03
Host: myhostname
===============================================
Planes currently tracked: 7
Planes with callsign:     5

Flight    | Airline              | Alt(ft) | Speed(kt) | Latitude   | Longitude  | RSSI(dB)
-------------------------------------------------------------------------------------------
UAL297    | United Airlines      | 14125   | 278.8     | 39.667162  | -104.95874 | -20.6
FFT1863   | Frontier Airlines    | 11925   | 265.0     | 39.801727  | -104.84032 | -19.1
N87654    | Private/Gen Aviation | 6200    | 188.0     | 39.875000  | -105.22222 | -14.5
...

Showing 5 of 7 planes with callsigns.
```

---

## Airline Identification

Airlines are mapped by callsign prefix in the `identify_airline()` function. Easily add new carriers or adjust existing mappings as needed.

---

## Customization

* **Output formatting:** Adjust `printf` field widths to change column spacing.
* **Airline mapping:** Add or change codes in the `identify_airline()` function.
* **Alerting:** Add extra logic to filter or alert on special flights.

---

## License

MIT License. Contributions, improvements, and issue reports are welcome!
