# Shiny MMM App with Prophet Forecast

## Introduction

This repository contains a Shiny app built in R for Media Mix Model (MMM) analysis and forecasting using the `prophet` package. The app is designed as a proof-of-concept for a startup that provides MMM services to clients and is exploring the possibility of commercializing their logic through a SaaS platform. The app allows users to visualize historical revenue data, analyze MMM metrics, and project future sales using the Prophet forecasting algorithm.

## MMM Overview

Media Mix Model (MMM) is a statistical approach used to analyze the effectiveness of different marketing channels and advertising spend on overall revenue. MMM helps businesses optimize their marketing strategies by understanding the impact of each marketing channel on sales and identifying the most effective allocation of resources.

## Features

- **Historical Revenue Visualization**: The app provides an interactive line plot that visualizes historical revenue data over time.

- **MMM Metrics**: Users can explore various MMM metrics, including total spent, media efficiency, and more, in a tabular format.

- **Prophet Forecasting**: The app utilizes the `prophet` package to generate future sales forecasts. It projects sales for the next year based on historical trends and patterns in the revenue data.

## Dockerized Deployment

To run the container locally, run `bash run-container.sh`