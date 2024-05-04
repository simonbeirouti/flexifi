"use client";

import React, { useEffect, useState } from "react";
import { useScaffoldReadContract } from "~~/hooks/scaffold-eth";

export default function ProgressBar() {
  const [progress, setProgress] = useState(0);
  const [totalAssets, setTotalAssets] = useState(0);

  // const { data: totalCounter, isLoading, error } = useScaffoldReadContract({
  const {
    data: totalCounter,
    isLoading,
    error,
  } = useScaffoldReadContract({
    contractName: "BusinessPooling",
    functionName: "totalAssets",
    watch: true,
  });

  console.log(totalCounter);

  useEffect(() => {
    if (totalCounter) {
      console.log("Total Assets from Contract:", totalCounter.toString());
      const total = parseInt(totalCounter.toString(), 10);
      setTotalAssets(total);
      setProgress((total / 100) * 100); // Assuming 100 is the max value for total assets for full progress
    }
  }, [totalCounter]);

  if (error) {
    console.error("Error fetching contract data:", error);
    return <div>Error loading data from the contract.</div>;
  }

  if (isLoading) {
    return <div>Loading...</div>;
  }

  // const simulateLoading = () => {
  //   const interval = setInterval(() => {
  //     setProgress(prevProgress => {
  //       if (prevProgress >= 100) {
  //         clearInterval(interval);

  //         return 100;
  //       }
  //       return prevProgress + 1;
  //     });
  //   }, 100);
  // };

  return (
    <div className="w-[64rem] mx-auto">
      <div className="py-1">We&apos;ve raised {totalAssets}</div>
      <div className="w-full h-12 rounded-lg bg-gray-200">
        <div
          className="h-full bg-blue-500 transition-width duration-300"
          style={{ width: `${progress}%`, borderRadius: "0.5rem" }}
        ></div>
      </div>
      {/* <button className="mt-4 p-2 bg-blue-500 text-white items-center mx-auto" onClick={simulateLoading}>
        Start Loading
      </button> */}
    </div>
  );
}
