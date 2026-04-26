export type ProvinceData = {
  id: string;
  name: string;
  prevalence: number;
  status: "Aman" | "Waspada" | "Kritis";
  statusColor: string;
};

const determineStatus = (prevalence: number) => {
  if (prevalence >= 30.0) return { status: "Kritis" as const, color: "text-red-600 bg-red-100" };
  if (prevalence >= 20.0) return { status: "Waspada" as const, color: "text-amber-600 bg-amber-100" };
  return { status: "Aman" as const, color: "text-emerald-700 bg-emerald-100" };
};

// Data mentah SSGI 2024
const rawData = [
  { id: "ACEH", name: "ACEH", prevalence: 28.6 },
  { id: "SUMUT", name: "SUMATERA UTARA", prevalence: 22.0 },
  { id: "SUMBAR", name: "SUMATERA BARAT", prevalence: 24.9 },
  { id: "RIAU", name: "RIAU", prevalence: 20.1 },
  { id: "JAMBI", name: "JAMBI", prevalence: 17.1 },
  { id: "SUMSEL", name: "SUMATERA SELATAN", prevalence: 15.9 },
  { id: "BENGKULU", name: "BENGKULU", prevalence: 18.8 },
  { id: "LAMPUNG", name: "LAMPUNG", prevalence: 15.9 },
  { id: "BABEL", name: "BANGKA BELITUNG", prevalence: 20.1 },
  { id: "KEPRI", name: "KEPULAUAN RIAU", prevalence: 15.0 },
  { id: "DKI", name: "DKI JAKARTA", prevalence: 17.3 },
  { id: "JABAR", name: "JAWA BARAT", prevalence: 15.9 },
  { id: "JATENG", name: "JAWA TENGAH", prevalence: 17.1 },
  { id: "DIY", name: "DI YOGYAKARTA", prevalence: 17.4 },
  { id: "JATIM", name: "JAWA TIMUR", prevalence: 14.7 },
  { id: "BANTEN", name: "BANTEN", prevalence: 21.1 },
  { id: "BALI", name: "BALI", prevalence: 8.7 },
  { id: "NTB", name: "NUSA TENGGARA BARAT", prevalence: 29.8 },
  { id: "NTT", name: "NUSA TENGGARA TIMUR", prevalence: 37.0 },
  { id: "KALBAR", name: "KALIMANTAN BARAT", prevalence: 26.8 },
  { id: "KALTENG", name: "KALIMANTAN TENGAH", prevalence: 22.1 },
  { id: "KALSEL", name: "KALIMANTAN SELATAN", prevalence: 22.9 },
  { id: "KALTIM", name: "KALIMANTAN TIMUR", prevalence: 22.2 },
  { id: "KALTARA", name: "KALIMANTAN UTARA", prevalence: 17.6 },
  { id: "SULUT", name: "SULAWESI UTARA", prevalence: 21.3 },
  { id: "SULTENG", name: "SULAWESI TENGAH", prevalence: 27.2 },
  { id: "SULSEL", name: "SULAWESI SELATAN", prevalence: 27.4 },
  { id: "SULTRA", name: "SULAWESI TENGGARA", prevalence: 30.0 },
  { id: "GORONTALO", name: "GORONTALO", prevalence: 26.9 },
  { id: "SULBAR", name: "SULAWESI BARAT", prevalence: 30.3 },
  { id: "MALUKU", name: "MALUKU", prevalence: 28.4 },
  { id: "MALUT", name: "MALUKU UTARA", prevalence: 24.7 },
  { id: "PABAR", name: "PAPUA BARAT", prevalence: 24.8 },
  { id: "PAPUA", name: "PAPUA", prevalence: 28.6 },
  { id: "PASEL", name: "PAPUA SELATAN", prevalence: 24.9 },
  { id: "PATENG", name: "PAPUA TENGAH", prevalence: 39.4 },
  { id: "PAPEG", name: "PAPUA PEGUNGUNGAN", prevalence: 36.9 },
  { id: "PBD", name: "PAPUA BARAT DAYA", prevalence: 31.4 },
];

// Mapping agar setiap objek memiliki 'status' dan 'statusColor'
export const PROVINCE_STATS: ProvinceData[] = rawData.map(p => {
  const { status, color } = determineStatus(p.prevalence);
  return { ...p, status, statusColor: color };
});

export const getStuntingColor = (prevalence: number) => {
  if (prevalence >= 30.0) return "#EF4444"; // Merah
  if (prevalence >= 20.0) return "#F59E0B"; // Amber
  return "#10B981"; // Emerald/Hijau
};