import { PROVINCE_STATS } from "@/lib/constants";
import { X, MapPin } from "lucide-react";

type ProvinceSidebarProps = {
  selectedProvinceId: string | null;
  onClose: () => void;
};

export default function ProvinceSidebar({ selectedProvinceId, onClose }: ProvinceSidebarProps) {
  if (!selectedProvinceId) return null;

  const province = PROVINCE_STATS.find((p) => p.id === selectedProvinceId);
  if (!province) return null;

  return (
    <div className="absolute top-4 right-4 w-80 glass-card rounded-2xl p-6 z-[1000] shadow-lg animate-in fade-in slide-in-from-right-8 duration-300">
      
      {/* Header */}
      <div className="flex justify-between items-start mb-4">
        <div>
          <h2 className="text-xl font-bold text-slate-800 leading-tight">
            {province.name}
          </h2>
          <div className="flex items-center text-emerald-600 mt-1">
            <MapPin size={14} className="mr-1" />
            <span className="text-xs font-semibold uppercase tracking-wider">SSGI 2024</span>
          </div>
        </div>
        <button 
          onClick={onClose} 
          className="p-1.5 bg-slate-100 hover:bg-slate-200 text-slate-500 rounded-full transition-colors"
        >
          <X size={18} />
        </button>
      </div>

      {/* Main Stat Card */}
      <div className="bg-white rounded-xl border border-emerald-100 p-5 mt-6 card-lift">
        <p className="text-slate-500 text-xs font-semibold uppercase mb-1">
          Angka Prevalensi
        </p>
        <div className="flex items-end gap-2">
          <span className="text-4xl font-black text-emerald-800 counter">
            {province.prevalence.toFixed(1)}
          </span>
          <span className="text-lg font-bold text-slate-400 mb-1">%</span>
        </div>

        {/* Status Badge */}
        <div className={`mt-4 inline-flex px-3 py-1.5 rounded-lg text-sm font-bold ${province.statusColor}`}>
          <div className="w-2 h-2 rounded-full bg-current opacity-75 mr-2 self-center dot-pulse"></div>
          Status: {province.status}
        </div>
      </div>

      {/* Aksi Tambahan (Opsional) */}
      <button className="w-full mt-6 bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3 px-4 rounded-xl shadow-md transition-colors">
        Lihat Detail Posyandu
      </button>

    </div>
  );
}