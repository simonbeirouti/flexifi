import React, { Fragment } from "react";

const data = [
  { name: "0x1234", percentage: 1 },
  { name: "0x5678", percentage: 2 },
  { name: "0x2349", percentage: 3 },
  { name: "0x1234", percentage: 1 },
  { name: "0x5678", percentage: 2 },
  { name: "0x2349", percentage: 3 },
  { name: "0x1234", percentage: 1 },
  { name: "0x5678", percentage: 2 },
  { name: "0x2349", percentage: 3 },
  { name: "0x1234", percentage: 1 },
  { name: "0x5678", percentage: 2 },
  { name: "0x2349", percentage: 3 },
  { name: "0x1234", percentage: 1 },
  { name: "0x5678", percentage: 2 },
  { name: "0x2349", percentage: 3 },
  { name: "0x1234", percentage: 1 },
  { name: "0x5678", percentage: 2 },
  { name: "0x2349", percentage: 3 },
  { name: "0x1234", percentage: 1 },
  { name: "0x5678", percentage: 2 },
  { name: "0x2349", percentage: 3 },
];

const transactions = [
  { time: "12:30PM", amount: 5000, token: "USDC", link: "https://tx.example.com/123" },
  { time: "14:45AM", amount: 3000, token: "USDT", link: "https://tx.example.com/456" },
  { time: "16:00AM", amount: 4500, token: "USDC", link: "https://tx.example.com/789" },
];

export default function PortfolioPage() {
  return (
    <Fragment>
      <LiveTrades />
      <div className="w-full flex flex-wrap px-4">
        {data.map((item, index) => (
          <div className="flex mr-2" key={index}>
            <p className="mr-2">{item.name}</p>
            <p>{item.percentage}%</p>
          </div>
        ))}
      </div>
      <Table />
    </Fragment>
  );
}

function Table() {
  return (
    <div className="w-full overflow-x-auto">
      <table className="w-full table-auto border-collapse">
        <thead>
          <tr className="bg-gray-100 dark:bg-gray-800">
            <th className="px-4 py-3 text-left font-medium text-gray-700 dark:text-gray-300">Name</th>
            <th className="px-4 py-3 text-left font-medium text-gray-700 dark:text-gray-300">Email</th>
            <th className="px-4 py-3 text-left font-medium text-gray-700 dark:text-gray-300">Phone</th>
            <th className="px-4 py-3 text-left font-medium text-gray-700 dark:text-gray-300">Address</th>
          </tr>
        </thead>
        <tbody>
          <tr className="border-b border-gray-200 dark:border-gray-700">
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">John Doe</td>
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">john@example.com</td>
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">123-456-7890</td>
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">123 Main St, Anytown USA</td>
          </tr>
          <tr className="border-b border-gray-200 dark:border-gray-700">
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">Jane Smith</td>
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">jane@example.com</td>
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">987-654-3210</td>
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">456 Oak Rd, Somewhere City</td>
          </tr>
          <tr className="border-b border-gray-200 dark:border-gray-700">
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">Bob Johnson</td>
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">bob@example.com</td>
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">555-555-5555</td>
            <td className="px-4 py-3 text-gray-700 dark:text-gray-300">789 Elm St, Somewhere Else</td>
          </tr>
        </tbody>
      </table>
    </div>
  );
}

function LiveTrades() {
  return (
    <div className="py-24 sm:py-32">
      <div className="mx-auto max-w-7xl px-6 lg:px-8">
        <div className="mx-auto max-w-2xl sm:text-center">
          <p className="mt-2 text-3xl font-bold tracking-tight text-white sm:text-4xl">We. Invest.</p>
          <p className="mt-6 text-lg leading-8 text-gray-300">Watch it in realtime</p>
        </div>
      </div>
      <div className="relative overflow-hidden pt-16">
        <div className="mx-auto max-w-7xl px-6 lg:px-8">
          <div className="flex flex-col bg-white/30 w-[32rem] h-96 p-2 rounded-md items-center mx-auto">
            {transactions.map((transaction, index) => (
              <div key={index} className="w-full h-16 bg-gray-300 mb-2 rounded-md flex flex-col text-black">
                <div className="flex flex-row justify-between m-2">
                  <span className="flex flex-col">
                    <span className="font-bold">{transaction.time}</span>
                    <div className="flex flex-row text-sm text-gray-600">
                      Link to transaction hash:{" "}
                      <a className="ml-1" href={transaction.link}>
                        0x....12314
                      </a>
                    </div>
                  </span>
                  <span className="flex justify-between items-center text-lg font-bold mr-4">
                    ${transaction.amount}
                    {transaction.token}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
