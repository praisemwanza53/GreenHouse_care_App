import streamlit as st
import requests
import time
import pandas as pd
import plotly.express as px
from chatbot import greenhouse_assistant

# IP address of the ESP32
ESP32_IP = "10.90.10.208"

# Navigation menu
st.sidebar.title("GREENHOUSE")
page = st.sidebar.radio("Go to", ["Greenhouse Monitoring", "GreenHouse Assistant"])

if page == "Greenhouse Monitoring":
    st.title("MONITORING AND CONTROLLING")

    def fetch_data():
        try:
            response = requests.get(f"http://{ESP32_IP}/data")
            if response.status_code == 200:
                data = response.text.split(',')
                expected_length = 10
                if len(data) < expected_length:
                    st.error(f"Incomplete data received: {data}")
                    return None
                
                # Adding a fallback for missing elements
                while len(data) < expected_length:
                    data.append('0')  # Append '0' or a default value to missing elements
                
                return {
                    "temperature": float(data[0]),
                    "humidity": float(data[1]),
                    "light": float(data[2]),
                    "soil_moisture": int(data[3]),
                    "voltage": float(data[4]),
                    "heater_status": data[5] == '1',
                    "fan_status": data[6] == '1',
                    "humidifier_status": data[7] == '1',
                    "pump_status": data[8] == '1',
                    "light_status": data[9] == '1'
                }
            else:
                st.error("Failed to fetch data from ESP32")
        except Exception as e:
            st.error(f"Error: {e}")
        return None

    def send_setpoints(temp, humidity, light, soil):
        try:
            response = requests.get(f"http://{ESP32_IP}/setpoints", params={
                "tempSetPoint": temp,
                "humiditySetPoint": humidity,
                "lightSetpoint": light,
                "soilSetpoint": soil
            })
            if response.status_code == 200:
                st.success("Setpoints updated successfully")
            else:
                st.error("Failed to update setpoints")
        except Exception as e:
            st.error(f"Error: {e}")

    def update_dataframe(df, data):
        new_row = {
            "Timestamp": pd.Timestamp.now(),
            "Temperature": data["temperature"],
            "Humidity": data["humidity"],
            "Light": data["light"],
            "Soil Moisture": data["soil_moisture"]
        }
        return pd.concat([df, pd.DataFrame([new_row])], ignore_index=True)

    def plot_data(df, temp_setpoint, humidity_setpoint, light_setpoint, soil_setpoint):
        # Update plots with actual data
        with temp_chart:
            st.subheader("Temperature Over Time")
            temp_fig = px.line(df, x="Timestamp", y="Temperature", title="Temperature Over Time")
            temp_fig.add_hline(y=temp_setpoint, line_dash="dash", line_color="red", annotation_text="Setpoint")
            st.plotly_chart(temp_fig, use_container_width=True)

        with humidity_chart:
            st.subheader("Humidity Over Time")
            humidity_fig = px.line(df, x="Timestamp", y="Humidity", title="Humidity Over Time")
            humidity_fig.add_hline(y=humidity_setpoint, line_dash="dash", line_color="red", annotation_text="Setpoint")
            st.plotly_chart(humidity_fig, use_container_width=True)

        with light_chart:
            st.subheader("Light Intensity Over Time")
            light_fig = px.line(df, x="Timestamp", y="Light", title="Light Intensity Over Time")
            light_fig.add_hline(y=light_setpoint, line_dash="dash", line_color="red", annotation_text="Setpoint")
            st.plotly_chart(light_fig, use_container_width=True)

        with soil_chart:
            st.subheader("Soil Moisture Over Time")
            soil_fig = px.line(df, x="Timestamp", y="Soil Moisture", title="Soil Moisture Over Time")
            soil_fig.add_hline(y=soil_setpoint, line_dash="dash", line_color="red", annotation_text="Setpoint")
            st.plotly_chart(soil_fig, use_container_width=True)

    # Setpoints
    st.header("Set Control Setpoints")
    temp = st.slider("Temperature Setpoint (°C)", min_value=0.0, max_value=50.0, value=23.0)
    humidity = st.slider("Humidity Setpoint (%)", min_value=0.0, max_value=100.0, value=60.0)
    light = st.slider("Light Intensity Setpoint (lx)", min_value=0, max_value=20000, value=5000)
    soil = st.slider("Soil Moisture Setpoint", min_value=0, max_value=2000, value=300)

    if st.button("Update Setpoints"):
        send_setpoints(temp, humidity, light, soil)

    # Real-Time Data
    st.header("Real-Time Data")
    
    # Initialize placeholders for metrics
    temperature_placeholder = st.empty()
    humidity_placeholder = st.empty()
    light_placeholder = st.empty()
    soil_moisture_placeholder = st.empty()
    voltage_placeholder = st.empty()
    
    # Initialize placeholders for statuses
    status_placeholder = st.empty()

    # Initialize placeholders for charts
    temp_chart = st.empty()
    humidity_chart = st.empty()
    light_chart = st.empty()
    soil_chart = st.empty()

    # Initialize the DataFrame
    data_df = pd.DataFrame(columns=["Timestamp", "Temperature", "Humidity", "Light", "Soil Moisture"])

    # Display initial placeholders while waiting for data
    with temperature_placeholder:
        st.metric(label="Temperature (°C)", value="Loading...")
    with humidity_placeholder:
        st.metric(label="Humidity (%)", value="Loading...")
    with light_placeholder:
        st.metric(label="Light Intensity (lx)", value="Loading...")
    with soil_moisture_placeholder:
        st.metric(label="Soil Moisture", value="Loading...")
    with voltage_placeholder:
        st.metric(label="Voltage (V)", value="Loading...")
    with status_placeholder:
        st.text("Waiting for status data...")

    # Initial placeholder charts with loading message
    with temp_chart:
        st.write("Loading temperature chart...")
    with humidity_chart:
        st.write("Loading humidity chart...")
    with light_chart:
        st.write("Loading light intensity chart...")
    with soil_chart:
        st.write("Loading soil moisture chart...")

    while True:
        data = fetch_data()
        if data:
            data_df = update_dataframe(data_df, data)
            
            # Update metrics with actual data
            with temperature_placeholder:
                st.metric(label="Temperature (°C)", value=data["temperature"])
            with humidity_placeholder:
                st.metric(label="Humidity (%)", value=data["humidity"])
            with light_placeholder:
                st.metric(label="Light Intensity (lx)", value=data["light"])
            with soil_moisture_placeholder:
                st.metric(label="Soil Moisture", value=data["soil_moisture"])
            with voltage_placeholder:
                st.metric(label="Voltage (V)", value=data["voltage"])
            with status_placeholder:
                st.text(f"Heater Status: {'ON' if data['heater_status'] else 'OFF'}")
                st.text(f"Fan Status: {'ON' if data['fan_status'] else 'OFF'}")
                st.text(f"Humidifier Status: {'ON' if data['humidifier_status'] else 'OFF'}")
                st.text(f"Pump Status: {'ON' if data['pump_status'] else 'OFF'}")
                st.text(f"Light Status: {'ON' if data['light_status'] else 'OFF'}")

            # Update the charts with actual data
            plot_data(data_df, temp, humidity, light, soil)

        time.sleep(10)

elif page == "GreenHouse Assistant":
    st.title("GREENHOUSE ASSISTANT")

    # Directly set the API key here
    api_key = "SECRET_KEY"

    # Call the chatbot from the separate file
    greenhouse_assistant(api_key)
