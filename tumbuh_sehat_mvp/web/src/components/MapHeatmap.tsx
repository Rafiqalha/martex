"use client";

import { useEffect, useState } from "react";
import { MapContainer, TileLayer, GeoJSON } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import { PROVINCE_STATS, getStuntingColor } from "@/lib/constants";

export default function MapHeatmap({ onSelect }: { onSelect: (id: string) => void }) {
  const [geoData, setGeoData] = useState<any>(null);

  useEffect(() => {
    fetch("https://raw.githubusercontent.com/ans-4175/peta-indonesia-geojson/master/indonesia-prov.geojson")
      .then((res) => res.json())
      .then((data) => setGeoData(data))
      .catch((err) => console.error(err));
  }, []);

  const onEachProvince = (feature: any, layer: any) => {
    layer.on({
      click: () => {
        const provinceName = feature.properties.Propinsi;
        const matchedProvince = PROVINCE_STATS.find(
          (p) => p.name.toUpperCase() === provinceName.toUpperCase()
        );
        if (matchedProvince) {
          onSelect(matchedProvince.id);
        }
      },
      mouseover: (e: any) => {
        const l = e.target;
        l.setStyle({ fillOpacity: 0.9, weight: 2, color: "#1F2937" });
        l.bringToFront();
      },
      mouseout: (e: any) => {
        const l = e.target;
        l.setStyle({ fillOpacity: 0.7, weight: 1, color: "white" });
      },
    });
  };

  const mapStyle = (feature: any) => {
    const provinceName = feature.properties.Propinsi;
    const matchedProvince = PROVINCE_STATS.find(
      (p) => p.name.toUpperCase() === provinceName.toUpperCase()
    );

    return {
      fillColor: matchedProvince ? getStuntingColor(matchedProvince.prevalence) : "#E5E7EB",
      weight: 1,
      opacity: 1,
      color: "white",
      fillOpacity: 0.7,
    };
  };

  return (
    <MapContainer 
      center={[-0.7893, 113.9213]} 
      zoom={5} 
      className="h-full w-full z-0"
    >

    <TileLayer url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" />
      {geoData && (
        <GeoJSON 
          data={geoData} 
          style={mapStyle} 
          onEachFeature={onEachProvince} 
        />
      )}
    </MapContainer>
  );
}