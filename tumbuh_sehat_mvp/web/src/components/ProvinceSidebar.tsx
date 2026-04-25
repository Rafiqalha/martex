import { PROVINCE_STATS, getStuntingColor } from "@/lib/constants";
import { AlertCircle, TrendingDown, Users, Activity, MapPin, Map, Download } from "lucide-react";

export default function ProvinceSidebar({ selectedId }: { selectedId: string | null }) {
  const province = PROVINCE_STATS.find((p) => p.id === selectedId);

  return (
    <div className="h-full flex flex-col">
      <div className="p-6 border-b border-gray-100 shrink-0">
        <h2 className="text-lg font-bold text-[#0F172A]">Analisis Wilayah</h2>
        <p className="text-sm text-gray-500 mt-1">Pilih area pada peta untuk detail</p>
      </div>

      <div className="flex-1 overflow-y-auto p-6">
        {province ? (
          <div className="space-y-6">
            <div>
              <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-gray-100 text-gray-600 text-xs font-semibold uppercase tracking-wider mb-3">
                <MapPin size={12} />
                Provinsi
              </div>
              <h3 className="text-2xl font-bold text-[#0F172A]">{province.name}</h3>
            </div>
            
            <div className="p-5 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden" style={{ backgroundColor: `${getStuntingColor(province.prevalence)}08` }}>
              <div className="absolute top-0 right-0 p-4 opacity-10">
                <Activity size={64} color={getStuntingColor(province.prevalence)} />
              </div>
              <label className="text-sm font-semibold text-gray-600 flex items-center gap-2">
                Prevalensi Saat Ini
              </label>
              <div className="mt-2 flex items-baseline gap-2">
                <p className="text-4xl font-black" style={{ color: getStuntingColor(province.prevalence) }}>
                  {province.prevalence}%
                </p>
                <span className="text-sm font-medium text-[#16A34A] flex items-center">
                  <TrendingDown size={14} className="mr-1" /> 1.2%
                </span>
              </div>
            </div>

            <div className="space-y-3">
              <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-100">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-white rounded-lg shadow-sm">
                    <AlertCircle size={16} className="text-gray-500" />
                  </div>
                  <span className="text-sm font-medium text-gray-600">Status Sistem</span>
                </div>
                <span className="text-sm font-bold text-[#0F172A] py-1 px-3 bg-white rounded-full border border-gray-200 shadow-sm">
                  {province.status}
                </span>
              </div>
              <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-100">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-white rounded-lg shadow-sm">
                    <Users size={16} className="text-gray-500" />
                  </div>
                  <span className="text-sm font-medium text-gray-600">Balita Diukur</span>
                </div>
                <span className="text-sm font-bold text-[#0F172A]">12,402</span>
              </div>
            </div>

            <div className="pt-4">
              <button className="w-full py-3.5 bg-[#0F172A] text-white rounded-xl font-medium hover:bg-gray-800 transition-all shadow-md flex items-center justify-center gap-2">
                <Download size={18} />
                Unduh Laporan Daerah
              </button>
            </div>
          </div>
        ) : (
          <div className="h-full flex flex-col items-center justify-center text-center px-4">
            <div className="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mb-4">
              <Map size={24} className="text-gray-300" />
            </div>
            <p className="text-sm font-medium text-gray-900 mb-1">Tidak ada area terpilih</p>
            <p className="text-sm text-gray-500">Klik salah satu provinsi pada peta untuk melihat analitik mendalam.</p>
          </div>
        )}
      </div>
    </div>
  );
}