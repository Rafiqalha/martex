"use client";

import { useEffect, useState } from "react";
import { MapContainer, TileLayer, GeoJSON } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import { PROVINCE_STATS, getStuntingColor } from "@/lib/constants";

export default function MapHeatmap({ onSelect }: { onSelect: (id: string) => void }) {
  const [geoData, setGeoData] = useState<any>(null);
  const [error, setError] = useState<string | null>(null);
  const [hoveredProvince, setHoveredProvince] = useState<string | null>(null);

  useEffect(() => {
    const fetchGeoData = async () => {
      try {
        const response = await fetch(
          "https://raw.githubusercontent.com/ans-4175/peta-indonesia-geojson/master/indonesia-prov.geojson"
        );

        if (!response.ok) {
          const textError = await response.text();
          throw new Error(
            `Gagal mengambil data peta (Status: ${response.status}). Respons: ${textError.substring(0, 30)}`
          );
        }

        const data = await response.json();
        setGeoData(data);
      } catch (err: any) {
        console.error("Fetch GeoJSON Error:", err);
        setError(err.message);
      }
    };

    fetchGeoData();
  }, []);

  const getMatchedProvince = (feature: any) => {
    const rawName = (
      feature.properties.Propinsi ||
      feature.properties.NAME_1 ||
      ""
    ).toUpperCase();
    return PROVINCE_STATS.find(
      (p) => rawName.includes(p.name) || p.name.includes(rawName)
    );
  };

  const onEachProvince = (feature: any, layer: any) => {
    const matched = getMatchedProvince(feature);

    // Tooltip label
    const provinceName =
      feature.properties.Propinsi ||
      feature.properties.NAME_1 ||
      "Tidak diketahui";

    layer.bindTooltip(
      `<div style="
        background: white;
        border: 1.5px solid #D1FAE5;
        border-radius: 10px;
        padding: 8px 12px;
        font-family: sans-serif;
        font-size: 13px;
        color: #065F46;
        box-shadow: 0 4px 12px rgba(16,185,129,0.15);
        pointer-events: none;
      ">
        <div style="font-weight: 900; margin-bottom: 2px;">${provinceName}</div>
        ${
          matched
            ? `<div style="color:#6B7280; font-size:11px;">
                Stunting: <strong style="color:#065F46">${matched.prevalence}%</strong>
              </div>`
            : `<div style="color:#9CA3AF; font-size:11px;">Data belum tersedia</div>`
        }
      </div>`,
      {
        permanent: false,
        sticky: true,
        className: "custom-tooltip",
        offset: [12, 0],
      }
    );

    layer.on({
      click: () => {
        if (matched) onSelect(matched.id);
      },
      mouseover: (e: any) => {
        const l = e.target;
        l.setStyle({
          fillOpacity: 1,
          weight: 2.5,
          color: "#065F46",   // border hijau tua saat hover
          dashArray: "",
        });
        l.bringToFront();
        setHoveredProvince(provinceName);
      },
      mouseout: (e: any) => {
        const l = e.target;
        l.setStyle({
          fillOpacity: 0.75,
          weight: 1.5,
          color: "#FFFFFF",   // border putih normal
          dashArray: "",
        });
        setHoveredProvince(null);
      },
    });
  };

  // Warna choropleth: putih → hijau daun berdasarkan tingkat stunting
  const mapStyle = (feature: any) => {
    const matched = getMatchedProvince(feature);

    return {
      // Jika tidak ada data → abu sangat muda
      // Jika ada data → skala hijau berdasarkan prevalensi
      fillColor: matched
        ? getLeafGreenColor(matched.prevalence)
        : "#F1F5F9",
      weight: 1.5,
      opacity: 1,
      color: "#FFFFFF",       // garis batas provinsi putih bersih
      fillOpacity: 0.75,
    };
  };

  if (error) {
    return (
      <div className="h-full w-full flex flex-col items-center justify-center bg-white gap-3">
        <div className="text-4xl">🗺️</div>
        <p className="text-sm text-red-500 font-semibold text-center px-6">
          Peta gagal dimuat. Periksa koneksi internet Anda.
        </p>
        <button
          onClick={() => window.location.reload()}
          className="text-xs bg-emerald-600 text-white px-4 py-2 rounded-full font-bold hover:bg-emerald-700 transition"
        >
          Muat Ulang
        </button>
      </div>
    );
  }

  return (
    <div className="relative h-full w-full rounded-2xl overflow-hidden">

      {/* ── Loading skeleton ── */}
      {!geoData && (
        <div className="absolute inset-0 z-10 flex flex-col items-center justify-center bg-white gap-3">
          <div className="w-10 h-10 border-4 border-emerald-200 border-t-emerald-600 rounded-full animate-spin" />
          <p className="text-sm text-emerald-700 font-semibold">Memuat peta Indonesia…</p>
        </div>
      )}

      {/* ── Legenda ── */}
      <div
        className="
          absolute bottom-6 left-4 z-[999]
          bg-white/90 backdrop-blur-sm
          border border-emerald-100
          rounded-2xl shadow-lg shadow-emerald-100/50
          px-4 py-3
          flex flex-col gap-2
        "
      >
        <p className="text-[11px] font-black text-emerald-900 uppercase tracking-wider">
          Prevalensi Stunting
        </p>

        <div className="flex flex-col gap-1.5">
          {LEGEND_ITEMS.map((item) => (
            <div key={item.label} className="flex items-center gap-2">
              <div
                className="w-4 h-4 rounded-md flex-shrink-0 border border-white shadow-sm"
                style={{ backgroundColor: item.color }}
              />
              <span className="text-[11px] text-slate-600 font-medium">
                {item.label}
              </span>
            </div>
          ))}
        </div>

        <div className="pt-1 border-t border-emerald-100">
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded-md bg-slate-100 border border-slate-200 flex-shrink-0" />
            <span className="text-[11px] text-slate-400">Data belum ada</span>
          </div>
        </div>
      </div>

      {/* ── Hovered province label ── */}
      {hoveredProvince && (
        <div
          className="
            absolute top-4 left-1/2 -translate-x-1/2 z-[999]
            bg-white/95 backdrop-blur-sm
            border border-emerald-200
            rounded-full shadow-md
            px-4 py-1.5
            pointer-events-none
          "
        >
          <p className="text-[13px] font-bold text-emerald-800">{hoveredProvince}</p>
        </div>
      )}

      {/* ── Map ── */}
      <MapContainer
        center={[-2.5, 118]}
        zoom={5}
        className="h-full w-full z-0"
        zoomControl={false}
        attributionControl={false}
      >
        {/* Tile: putih bersih dari CartoDB Positron */}
        <TileLayer
          url="https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{r}.png"
          attribution='&copy; <a href="https://carto.com">CARTO</a>'
        />

        {/* Label kota (transparan, tanpa background kotor) */}
        <TileLayer
          url="https://{s}.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}{r}.png"
          attribution=""
          zIndex={10}
        />

        {geoData && (
          <GeoJSON
            key={JSON.stringify(geoData).length}  // force re-render jika data berubah
            data={geoData}
            style={mapStyle}
            onEachFeature={onEachProvince}
          />
        )}
      </MapContainer>

      {/* ── Watermark ── */}
      <div className="absolute bottom-3 right-4 z-[999]">
        <p className="text-[10px] text-slate-300 font-medium">
          Data: Kemenkes RI · WHO Standards
        </p>
      </div>
    </div>
  );
}


// ══════════════════════════════════════════════════
// SKALA WARNA HIJAU DAUN
// Putih → hijau muda → hijau daun → hijau tua
// Makin tinggi stunting = makin gelap
// ══════════════════════════════════════════════════
function getLeafGreenColor(prevalence: number): string {
  if (prevalence < 10)  return "#F0FDF4"; // hampir putih — sangat rendah
  if (prevalence < 15)  return "#DCFCE7"; // hijau sangat muda
  if (prevalence < 20)  return "#86EFAC"; // hijau muda
  if (prevalence < 25)  return "#4ADE80"; // hijau segar
  if (prevalence < 30)  return "#22C55E"; // hijau daun
  if (prevalence < 35)  return "#16A34A"; // hijau sedang
  if (prevalence < 40)  return "#15803D"; // hijau tua
  return "#14532D";                        // hijau sangat tua — kritis
}

const LEGEND_ITEMS = [
  { color: "#F0FDF4", label: "< 10%  — Sangat Rendah" },
  { color: "#DCFCE7", label: "10–15% — Rendah" },
  { color: "#86EFAC", label: "15–20% — Sedang" },
  { color: "#4ADE80", label: "20–25% — Cukup Tinggi" },
  { color: "#22C55E", label: "25–30% — Tinggi" },
  { color: "#16A34A", label: "30–35% — Sangat Tinggi" },
  { color: "#14532D", label: "> 35%  — Kritis" },
];