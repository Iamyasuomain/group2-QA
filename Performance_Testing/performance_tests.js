import http from 'k6/http';
import { check, sleep } from 'k6';

// =================================================================
// 1. BASE CONFIGURATION - DEFAULT FUNCTION
//    This defines the action (User Behavior) for all tests.
// =================================================================

// Ensure this URL points to the product page you are testing
const PRODUCT_URL = 'http://10.34.112.158:8000/gb';

export default function () {
  // Simulate a user accessing a single, resource-intensive page
  let res = http.get(PRODUCT_URL);
  
  // Checks to ensure the request was successful
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time is < 1s': (r) => r.timings.duration < 1000,
  });

  // User "think time" between actions to simulate realistic behavior
  sleep(1); 
}

// =================================================================
// 2. K6 OPTIONS - UNCOMMENT THE BLOCK FOR THE TEST YOU WANT TO RUN
// =================================================================

// ---------------------------------------------------------------
// A. Average-Load Test Options (Test for Normal Usage)
// ---------------------------------------------------------------

// export let options = {
//   vus: 50,       // 50 concurrent virtual users (Your expected average load)
//   duration: '5m', // Run for 5 minutes
//   tags: { test_type: 'average_load' },
//   thresholds: {
//     'http_req_duration': ['p(95) < 1000'], // 95% of requests must be faster than 1 second
//     'http_req_failed': ['rate < 0.01'],    // Failure rate should be below 1%
//   },
// };


// ---------------------------------------------------------------
// B. Stress Test Options (Find the Breakpoint)
// ---------------------------------------------------------------
// 
// export let options = {
//   stages: [
//     { duration: '5m', target: 100 },  // Gradual increase to expected maximum
//     { duration: '5m', target: 200 },  // Pushing past expected limit (Stress Zone)
//     { duration: '3m', target: 300 },  // Reaching the potential breaking point
//     { duration: '2m', target: 0 },    // Cool-down period
//   ],
//   tags: { test_type: 'stress' },
// };
// */

// ---------------------------------------------------------------
// C. Soak Test Options (Test Long-Term Stability/Memory Leaks)
// ---------------------------------------------------------------

// export let options = {
//   vus: 50,         // Using the average load
//   duration: '4h',  // Running for 4 hours (Long duration)
//   tags: { test_type: 'soak' },
//   // No strict thresholds needed; focus is on stability over time
// };


// ---------------------------------------------------------------
// D. Spike Test Options (Test Resilience and Recovery Time)
// ---------------------------------------------------------------

export let options = {
  stages: [
    { duration: '5m', target: 50 },   // Establish Base Load
    { duration: '1m', target: 250 },  // SUDDEN SPIKE! (5x the base load)
    { duration: '5m', target: 50 },   // Recovery back to Base Load
  ],
  tags: { test_type: 'spike' },
};
