"use client";

import dynamic from "next/dynamic";
import { useState } from "react";

const MapHeatmap = dynamic<{ data: any[] }>(
  () => import("../components/MapHeatmap"), 
  { ssr: false }
);

export default function Dashboard() {
  const [measurements, setMeasurements] = useState([
    { lat: -6.2088, lng: 106.8456, age: 24, z_score: -2.5 },
    { lat: -7.2504, lng: 112.7688, age: 12, z_score: -1.2 },
    { lat: -0.9471, lng: 100.4172, age: 36, z_score: -3.1 },
    { lat: 3.5952, lng: 98.6722, age: 18, z_score: -0.5 },
    { lat: -5.1476, lng: 119.4327, age: 48, z_score: -2.8 }
  ]);

  return (
    <div className="min-h-screen bg-[#FCFDFD] p-8 font-sans">
      <header className="mb-8">
        <h1 className="text-3xl font-bold text-[#1F2937]">TumbuhSehat Command Center</h1>
        <p className="text-[#6B7280] mt-1">Sistem Pemantauan Stunting Real-Time Nasional</p>
      </header>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-white p-6 rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] border border-gray-100">
          <h3 className="text-[#6B7280] text-sm font-semibold uppercase tracking-wider">Total Pengukuran (Live)</h3>
          <p className="text-4xl font-bold text-[#1F2937] mt-2">1,204</p>
        </div>
        <div className="bg-white p-6 rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] border border-gray-100">
          <h3 className="text-[#6B7280] text-sm font-semibold uppercase tracking-wider">Risiko Tinggi (Z-Score &lt; -2)</h3>
          <p className="text-4xl font-bold text-[#EF4444] mt-2">18.5%</p>
        </div>
        <div className="bg-white p-6 rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] border border-gray-100">
          <h3 className="text-[#6B7280] text-sm font-semibold uppercase tracking-wider">Desa Terkoneksi</h3>
          <p className="text-4xl font-bold text-[#16A34A] mt-2">42</p>
        </div>
      </div>

      <div className="bg-white p-2 rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] border border-gray-100 h-[550px] relative z-0">
        <MapHeatmap data={measurements} />
      </div>
    </div>
  );
}