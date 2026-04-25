"use client";

import dynamic from "next/dynamic";
import { useState } from "react";
import { LayoutDashboard, Users, Map, Settings, Download, Search, Activity } from "lucide-react";
import ProvinceSidebar from "@/components/ProvinceSidebar";

const MapHeatmap = dynamic<{ onSelect: (id: string) => void }>(
  () => import("../components/MapHeatmap"), 
  { ssr: false }
);

export default function Dashboard() {
  const [selectedProvinceId, setSelectedProvinceId] = useState<string | null>(null);

  return (
    <div className="flex h-screen bg-[#090C15] font-sans overflow-hidden bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-[#1F2937]/40 via-[#090C15] to-[#090C15]">
      
      {/* SIDEBAR - GLASSMORPHISM */}
      <aside className="w-20 lg:w-64 bg-white/5 backdrop-blur-xl border-r border-white/10 flex flex-col shrink-0 z-10 shadow-[4px_0_24px_rgba(0,0,0,0.5)]">
        <div className="h-20 flex items-center justify-center lg:justify-start lg:px-6 border-b border-white/10">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-[#10B981] to-[#047857] shadow-[0_0_15px_rgba(16,185,129,0.5)]"></div>
          <span className="hidden lg:block ml-3 font-[family-name:var(--font-space)] font-bold text-xl tracking-wide text-white">Tumbuh<span className="text-[#10B981]">Sehat</span></span>
        </div>
        <nav className="flex-1 py-8 flex flex-col gap-3 px-4">
          <a href="#" className="flex items-center gap-3 px-4 py-3 bg-white/10 text-[#10B981] rounded-xl font-medium border border-white/5 shadow-[inset_0_1px_1px_rgba(255,255,255,0.1)] transition-all">
            <LayoutDashboard size={20} />
            <span className="hidden lg:block text-sm">War Room</span>
          </a>
          <a href="#" className="flex items-center gap-3 px-4 py-3 text-gray-400 hover:text-white hover:bg-white/5 rounded-xl font-medium transition-all duration-300">
            <Map size={20} />
            <span className="hidden lg:block text-sm">Pemetaan</span>
          </a>
          <a href="#" className="flex items-center gap-3 px-4 py-3 text-gray-400 hover:text-white hover:bg-white/5 rounded-xl font-medium transition-all duration-300">
            <Users size={20} />
            <span className="hidden lg:block text-sm">Intelijen Data</span>
          </a>
        </nav>
      </aside>

      <main className="flex-1 flex flex-col h-screen overflow-hidden relative">
        {/* HEADER */}
        <header className="h-20 bg-white/5 backdrop-blur-md border-b border-white/10 flex items-center justify-between px-8 shrink-0 z-10">
          <div className="flex items-center gap-5">
            <h1 className="text-xl font-bold text-white font-[family-name:var(--font-space)] tracking-wide">Nasional Overview</h1>
            <div className="h-6 w-px bg-white/20"></div>
            <div className="flex items-center gap-2">
              <span className="relative flex h-3 w-3">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-[#10B981] opacity-75"></span>
                <span className="relative inline-flex rounded-full h-3 w-3 bg-[#10B981]"></span>
              </span>
              <span className="text-sm font-medium text-gray-400">Live Sync Active</span>
            </div>
          </div>
          <button className="flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-[#10B981] to-[#059669] text-white rounded-lg text-sm font-bold shadow-[0_0_20px_rgba(16,185,129,0.3)] hover:shadow-[0_0_30px_rgba(16,185,129,0.5)] transition-all duration-300">
            <Download size={16} />
            Export Laporan BGN
          </button>
        </header>

        <div className="flex-1 overflow-y-auto p-8 z-0">
          {/* KPI CARDS - MICRO ANIMATIONS */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div className="bg-white/5 backdrop-blur-lg p-6 rounded-2xl border border-white/10 shadow-xl hover:-translate-y-1 hover:bg-white/10 transition-all duration-300 relative overflow-hidden group">
              <div className="absolute top-0 right-0 p-4 opacity-5 group-hover:opacity-10 transition-opacity"><Activity size={80} /></div>
              <h3 className="text-sm font-medium text-gray-400 mb-2 uppercase tracking-wider">Total Data Masuk</h3>
              <div className="flex items-end gap-3">
                <span className="text-4xl font-bold text-white font-[family-name:var(--font-space)]">2.4<span className="text-2xl text-gray-500"> Juta</span></span>
              </div>
            </div>
            
            <div className="bg-white/5 backdrop-blur-lg p-6 rounded-2xl border border-white/10 shadow-xl hover:-translate-y-1 hover:bg-white/10 transition-all duration-300">
              <h3 className="text-sm font-medium text-gray-400 mb-2 uppercase tracking-wider">Prevalensi Nasional</h3>
              <div className="flex items-end gap-3">
                <span className="text-4xl font-bold text-[#10B981] font-[family-name:var(--font-space)] drop-shadow-[0_0_10px_rgba(16,185,129,0.5)]">18.4%</span>
                <span className="text-sm font-medium text-[#10B981] mb-1 bg-[#10B981]/20 px-2 py-0.5 rounded text-xs">-2.1% (MoM)</span>
              </div>
            </div>

            <div className="bg-white/5 backdrop-blur-lg p-6 rounded-2xl border border-white/10 shadow-xl hover:-translate-y-1 hover:bg-white/10 transition-all duration-300">
              <h3 className="text-sm font-medium text-gray-400 mb-2 uppercase tracking-wider">Provinsi Kritis (&gt;30%)</h3>
              <div className="flex items-end gap-3">
                <span className="text-4xl font-bold text-[#EF4444] font-[family-name:var(--font-space)] drop-shadow-[0_0_10px_rgba(239,68,68,0.5)]">4</span>
                <span className="text-sm font-medium text-gray-400 mb-1">Wilayah</span>
              </div>
            </div>
          </div>

          {/* MAIN RADAR MAP & SIDEBAR */}
          <div className="flex flex-col lg:flex-row gap-6 h-[550px]">
            {/* MAP CONTAINER */}
            <div className="flex-1 bg-white/5 backdrop-blur-lg rounded-2xl border border-white/10 shadow-2xl overflow-hidden relative group">
              <MapHeatmap onSelect={setSelectedProvinceId} />
              
              {/* GLASS LEGEND */}
              <div className="absolute bottom-6 left-6 z-[1000] bg-[#090C15]/80 backdrop-blur-md p-5 rounded-xl border border-white/10 shadow-2xl">
                <h4 className="text-xs font-bold text-gray-300 uppercase tracking-widest mb-4 font-[family-name:var(--font-space)]">Status Wilayah</h4>
                <div className="space-y-3">
                  <div className="flex items-center gap-3"><div className="w-3 h-3 rounded-full bg-[#EF4444] shadow-[0_0_10px_#EF4444]" /> <span className="text-xs font-medium text-gray-400">Bahaya (&gt; 30%)</span></div>
                  <div className="flex items-center gap-3"><div className="w-3 h-3 rounded-full bg-[#F59E0B] shadow-[0_0_10px_#F59E0B]" /> <span className="text-xs font-medium text-gray-400">Waspada (20% - 30%)</span></div>
                  <div className="flex items-center gap-3"><div className="w-3 h-3 rounded-full bg-[#10B981] shadow-[0_0_10px_#10B981]" /> <span className="text-xs font-medium text-gray-400">Terkendali (&lt; 20%)</span></div>
                </div>
              </div>
            </div>
            
            {/* SIDEBAR DATA */}
            <div className="w-full lg:w-96 bg-white/5 backdrop-blur-lg rounded-2xl border border-white/10 shadow-2xl overflow-hidden flex flex-col shrink-0">
              <ProvinceSidebar selectedId={selectedProvinceId} />
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}