"use client";

import { useEffect, useState } from "react";

type ProvinceData = {
  id: string;
  name: string;
  prevalence: number;
  status: "aman" | "waspada" | "bahaya";
  cases: number;
};

type ProvinceSidebarProps = {
  selectedId: string | null;
};

export default function ProvinceSidebar({ selectedId }: ProvinceSidebarProps) {
  const [data, setData] = useState<ProvinceData | null>(null);
  const [loading, setLoading] = useState(false);

  // 🔥 Fetch data setiap selected berubah
  useEffect(() => {
    if (!selectedId) {
      setData(null);
      return;
    }

    const fetchData = async () => {
      setLoading(true);

      try {
        // ⚠️ sementara mock dulu (nanti ganti API)
        await new Promise((res) => setTimeout(res, 500));

        // Dummy data (simulasi backend)
        const mock: ProvinceData = {
          id: selectedId,
          name: "Jawa Timur",
          prevalence: 21.3,
          status: "waspada",
          cases: 12430,
        };

        setData(mock);
      } catch (err) {
        console.error(err);
        setData(null);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [selectedId]);

  // 🟡 Empty state
  if (!selectedId) {
    return (
      <div className="flex items-center justify-center h-full text-gray-400 text-sm">
        Pilih provinsi di peta
      </div>
    );
  }

  // 🔄 Loading state
  if (loading) {
    return (
      <div className="flex items-center justify-center h-full text-gray-400 text-sm">
        Memuat data...
      </div>
    );
  }

  // ❌ Error / tidak ada data
  if (!data) {
    return (
      <div className="flex items-center justify-center h-full text-red-400 text-sm">
        Gagal memuat data
      </div>
    );
  }

  // 🎨 Warna status
  const statusColor =
    data.status === "bahaya"
      ? "text-red-400"
      : data.status === "waspada"
      ? "text-yellow-400"
      : "text-green-400";

  const statusBg =
    data.status === "bahaya"
      ? "bg-red-500/20"
      : data.status === "waspada"
      ? "bg-yellow-500/20"
      : "bg-green-500/20";

  return (
    <div className="p-6 text-white flex flex-col gap-6">
      {/* HEADER */}
      <div>
        <h2 className="text-lg font-bold tracking-wide">
          {data.name}
        </h2>
        <p className="text-xs text-gray-400">ID: {data.id}</p>
      </div>

      {/* STATUS CARD */}
      <div
        className={`p-4 rounded-xl border border-white/10 ${statusBg}`}
      >
        <p className="text-xs text-gray-400 mb-1">Status Wilayah</p>
        <p className={`text-lg font-bold ${statusColor}`}>
          {data.status.toUpperCase()}
        </p>
      </div>

      {/* METRICS */}
      <div className="flex flex-col gap-4">
        <div className="bg-white/5 p-4 rounded-xl border border-white/10">
          <p className="text-xs text-gray-400 mb-1">
            Prevalensi Stunting
          </p>
          <p className="text-2xl font-bold text-white">
            {data.prevalence}%
          </p>
        </div>

        <div className="bg-white/5 p-4 rounded-xl border border-white/10">
          <p className="text-xs text-gray-400 mb-1">
            Total Kasus
          </p>
          <p className="text-2xl font-bold text-white">
            {data.cases.toLocaleString()}
          </p>
        </div>
      </div>

      {/* ACTION */}
      <button className="mt-auto w-full py-3 bg-gradient-to-r from-[#10B981] to-[#059669] rounded-lg text-sm font-bold shadow hover:shadow-lg transition-all">
        Lihat Detail Lengkap
      </button>
    </div>
  );
}