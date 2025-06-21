import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';

export default function App() {
  const call = async () => {
    console.log("fetch data: loading");

    const response = await fetch("https://jsonplaceholder.typicode.com/todos/1");

    const data = await response.json();

    console.log("fetch data:", data);
  }
  return (
    <View style={styles.container}>
      <Text onPress={call}>Open up App.js to start working on your app!</Text>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
