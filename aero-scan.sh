#!/bin/bash

# === CONFIG ===
JSON_FILE="path/to/aircraft.json"
REPORT="/tmp/plane_report.txt"
EMAIL_TO="youremail@address.com"
HOSTNAME=$(hostname)
DATETIME=$(date "+%Y-%m-%d %H:%M:%S")

identify_airline() {
  code="$1"
  case "$code" in
    AAL*) echo "American Airlines" ;;
    ACA*) echo "Air Canada" ;;
    AFR*) echo "Air France" ;;
    AMX*) echo "Aeromexico" ;;
    ANA*) echo "All Nippon Airways" ;;
    ASA*) echo "Alaska Airlines" ;;
    ASH*) echo "Mesa Airlines" ;;
    BAW*) echo "British Airways" ;;
    DAL*) echo "Delta Air Lines" ;;
    DLH*) echo "Lufthansa" ;;
    EDV*) echo "Endeavor Air (Delta Connection)" ;;
    EJA*) echo "NetJets (Private Jet)" ;;
    ENY*) echo "Envoy Air (American Eagle)" ;;
    FFT*) echo "Frontier Airlines" ;;
    FDX*) echo "FedEx" ;;
    GJS*) echo "GoJet Airlines" ;;
    JBU*) echo "JetBlue" ;;
    JAL*) echo "Japan Airlines" ;;
    KLM*) echo "KLM Royal Dutch Airlines" ;;
    NKS*) echo "Spirit Airlines" ;;
    QFA*) echo "Qantas" ;;
    QTR*) echo "Qatar Airways" ;;
    RPA*) echo "Republic Airways (American/United/Delta Connection)" ;;
    SKW*) echo "SkyWest" ;;
    SWA*) echo "Southwest Airlines" ;;
    UAE*) echo "Emirates" ;;
    UAL*) echo "United Airlines" ;;
    UPS*) echo "UPS" ;;
    VIR*) echo "Virgin Atlantic" ;;
    WJA*) echo "WestJet" ;;
    N[0-9]*) echo "Private/General Aviation" ;;
    XA[0-9]*) echo "Mexican Private/General Aviation" ;;
    C*) echo "Canadian Private/General Aviation" ;;
    *) echo "Unknown/Other" ;;
  esac
}

# === HEADER ===
{
  printf "✈️  Aero-Scan Report – %s\n" "$DATETIME"
  printf "Host: %s\n" "$HOSTNAME"
  printf "===============================================\n"
} > "$REPORT"

if [ ! -f "$JSON_FILE" ]; then
  echo "No aircraft.json file found at $JSON_FILE" >> "$REPORT"
else
  total_planes=$(jq '.aircraft | length' "$JSON_FILE")
  with_callsign=$(jq '[.aircraft[] | select(.flight != null)] | length' "$JSON_FILE")
  echo "Planes currently tracked: $total_planes" >> "$REPORT"
  echo "Planes with callsign:     $with_callsign" >> "$REPORT"
  echo "" >> "$REPORT"

  # Table Header with fixed widths for tight columns
  printf "%-9s | %-30s | %8s | %9s | %10s | %11s | %9s\n" \
    "Flight" "Airline" "Alt(ft)" "Speed(kt)" "Latitude" "Longitude" "RSSI(dB)" >> "$REPORT"
  printf "%s\n" "-----------------------------------------------------------------------------------------------------------" >> "$REPORT"

  # Table Rows
  jq -r '.aircraft[] | select(.flight != null) |
    "\(.flight)\t\(.alt_baro // "N/A")\t\(.gs // "N/A")\t\(.lat // "N/A")\t\(.lon // "N/A")\t\(.rssi // "N/A")"' \
    "$JSON_FILE" | \
    while IFS=$'\t' read -r flight alt speed lat lon rssi; do
      airline=$(identify_airline "$flight")
      printf "%-9s | %-18s | %8s | %9s | %10s | %11s | %9s\n" \
        "$flight" "$airline" "$alt" "$speed" "$lat" "$lon" "$rssi" >> "$REPORT"
    done

  printf "\nShowing %d of %d planes with callsigns.\n" "$with_callsign" "$total_planes" >> "$REPORT"
fi

cat "$REPORT" | mail -s "Aero-Scan Report [$HOSTNAME]" "$EMAIL_TO"
