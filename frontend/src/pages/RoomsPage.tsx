import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export function RoomsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Voice Rooms</h1>
        <p className="text-muted-foreground">
          Monitor active voice rooms
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Active Rooms</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground">No active rooms</p>
        </CardContent>
      </Card>
    </div>
  );
}
