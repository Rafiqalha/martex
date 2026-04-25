"use client";

import { MapContainer, TileLayer, CircleMarker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";

export default function MapHeatmap({ data }: { data: any[] }) {
  return (
    <MapContainer 
      center={[-0.7893, 113.9213]} 
      zoom={5} 
      style={{ height: "100%", width: "100%", borderRadius: "12px", zIndex: 0 }}
    >
      <TileLayer url="https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png" />
      {data.map((point, index) => (
        <CircleMarker
          key={index}
          center={[point.lat, point.lng]}
          radius={point.z_score < -2 ? 12 : 6}
          fillColor={point.z_score < -2 ? "#EF4444" : "#10B981"}
          color="transparent"
          fillOpacity={0.8}
        >
          <Popup>
            <div className="font-sans">
              <p className="font-bold">Usia: {point.age} bulan</p>
              <p>Z-Score: {point.z_score}</p>
            </div>
          </Popup>
        </CircleMarker>
      ))}
    </MapContainer>
  );
}