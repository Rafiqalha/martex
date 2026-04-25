export const PROVINCE_STATS = [
  { id: "31", name: "DKI Jakarta", prevalence: 14.8, status: "Normal" },
  { id: "32", name: "Jawa Barat", prevalence: 20.2, status: "Waspada" },
  { id: "53", name: "NTT", prevalence: 35.3, status: "Bahaya" },
  { id: "73", name: "Sulawesi Selatan", prevalence: 27.2, status: "Waspada" },
  { id: "94", name: "Papua", prevalence: 34.6, status: "Bahaya" },
];

export const getStuntingColor = (prevalence: number) => {
  return prevalence > 30
    ? "#EF4444" // Merah (Bahaya)
    : prevalence > 20
    ? "#F59E0B" // Oranye (Waspada)
    : prevalence > 10
    ? "#EAB308" // Kuning (Hati-hati)
    : "#10B981"; // Hijau (Aman)
};