"use client";

import React, { useState } from "react";

export default function ProgressBar() {
  const [progress, setProgress] = useState(0);

  const simulateLoading = () => {
    const interval = setInterval(() => {
      setProgress(prevProgress => {
        if (prevProgress >= 100) {
          clearInterval(interval);

          return 100;
        }
        return prevProgress + 1;
      });
    }, 100);
  };

  return (
    <div className="w-[64rem] mx-auto">
      <div className="py-1">We&apos;ve raised 123</div>
      <div className="w-full h-22 rounded-lg bg-gray-200">
        <div
          className="h-full bg-blue-500 transition-width duration-300"
          style={{ width: `${progress}%`, borderRadius: "0.5rem" }}
        ></div>
      </div>
      <button className="mt-4 p-2 bg-blue-500 text-white items-center mx-auto" onClick={simulateLoading}>
        Start Loading
      </button>
    </div>
  );
}
